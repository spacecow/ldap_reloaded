class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :membership

  attr_accessible :day_id, :member_id

  validates :day_id, :uniqueness => {:scope => :membership_id}
end
