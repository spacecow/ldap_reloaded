class Day < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy, :after_add => :inc_user_count
  has_many :memberships, :through => :dailystats

  attr_accessible :date, :users_count

  validates :date, presence:true, uniqueness:true

  class << self
    def generate_userlist(date_s,file = "ldap_info.txt")
      raise DayExistsException if Day.exists?(date:date_s)
      day = Day.create(date:date_s)
      hash = Ldapsearch.group_hash(file)
      memberships = Ldapsearch.find_or_create_accounts_and_memberships(hash, file)
      memberships.each do |membership|
        day.memberships << membership
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
