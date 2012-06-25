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
      members = Ldapsearch.create_accounts_and_members(hash, file)
      members.each do |member|
        member.days << day
      end
    end
  end
end
