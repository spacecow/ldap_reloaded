class Month < ActiveRecord::Base
  has_many :monthlystats
  has_many :memberships, :through => :monthlystats

  attr_accessible :date

  validates :date, uniqueness:true, presence:true

  def end_date
    date.end_of_month
  end
end
