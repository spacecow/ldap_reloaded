class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :membership
  belongs_to :monthlystat

  attr_accessible :day_id, :member_id

  validates :day_id, :uniqueness => {:scope => :membership_id}

  def create_or_update_montlystat(month)
    if membership.has_monthlystat_for?(month)
      mstat = membership.monthlystats.find_by_month_id(month.id)
      mstat.add_dailystat(self)
    else
      create_monthlystat(month_id:month.id, membership_id:membership.id)
      save
    end
  end
end
