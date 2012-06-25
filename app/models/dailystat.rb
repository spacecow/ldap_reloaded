class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :member

  attr_accessible :day_id, :member_id

  validates :day_id, :uniqueness => {:scope => :member_id}
end
