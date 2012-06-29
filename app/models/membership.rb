class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :group

  has_many :dailystats
  has_many :days, :through => :dailystats

  has_many :monthlystats
  has_many :months, :through => :monthlystats

  attr_accessible :path, :account_id, :group_id

  validates :account_id, presence:true, :uniqueness => {:scope => :group_id}
  validates :group_id, presence:true

  def first_date; first_day.date end
  def first_day; first_dailystat.day end
  def first_dailystat
    dailystats.order('days.date').includes(:day).first
  end
  def gid; group.gid end
  def gidname; group.gidname end
  def has_monthlystat_for?(month)
    months.include?(month)
  end
  def realname; account.realname end
  def uid; account.uid end
  def username; account.username end

  class << self
    def find_or_create(path, account, group)
      if account.memberships.exists?(group_id:group.id)
        account.memberships.find_by_group_id(group.id)
      else
        Membership.create(path:path, account_id:account.id, group_id:group.id)
      end
    end
  end
end
