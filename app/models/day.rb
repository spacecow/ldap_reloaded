class Day < ActiveRecord::Base
  has_many :dailystats
  has_many :members, :through => :dailystats

  attr_accessible :date, :users_count

  validates :date, uniqueness:true

  class << self
    def generate_userlist(date_s,file = "ldap_info.txt")
      raise DayExistsException if Day.exists?(date:date_s)
      day = Day.create(date:date_s)
      hash = Ldapsearch.group_hash(file)
      memberships = Ldapsearch.find_or_create_accounts_and_memberships(hash, file)
      memberships.each do |membership|
        membership.days << day
      end
    end
  end
end
