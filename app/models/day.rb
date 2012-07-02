class Day < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy, :after_add => :inc_user_count
  has_many :memberships, :through => :dailystats

  attr_accessible :date, :users_count

  validates :date, presence:true, uniqueness:true

  class << self
    def generate_userlist(date,file = "ldap_info.txt")
      raise DayExistsException if Day.exists?(date:date)
      day = Day.create(date:date)
      if Rails.env.production?
        %x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -x "(objectclass=*)" > data/ldap_info.txt]
      end
      hash = Ldapsearch.group_hash(file)
      memberships = Ldapsearch.find_or_create_accounts_and_memberships(hash, file)

      #create dailystats
      memberships.each do |membership|
        day.memberships << membership
      end

      #create monthlystats
      month_date = date.strftime("%Y-%m-01")
      month = Month.find_or_create_by_date(month_date) 

      #day.memberships.each do |mship|
      #  mship.create_or_update_monthlystat(month)
      #end
      day.dailystats.each do |dstat|
        dstat.create_or_update_montlystat(month)
      end
    end

    def generate_todays_userlist
      generate_userlist(Date.today)
    end
  end


  private

    def inc_user_count(dstat)
      update_attribute(:user_count, user_count+1)
    end
end
