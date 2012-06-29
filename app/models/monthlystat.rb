class Monthlystat < ActiveRecord::Base
  belongs_to :membership
  belongs_to :month

  has_many :dailystats, :after_add => :inc_day_count

  before_create :set_day_of_registration

  attr_accessible :membership_id, :month_id

  def account; membership.account end
  def add_dailystat(dstat)
    dailystats << dstat
  end
  def gid; membership.gid end
  def gidname; membership.gidname end
  def group; membership.group end
  def increase_and_save_day_count
    self.day_count += 1
    save
  end
  def month_count; (day_count / 30.0 + 0.5).to_i end
  def path; membership.path end
  def uid; membership.uid end
  def username; membership.username end

  private

    def inc_day_count(dstat)
      self.day_count += 1
      save
    end
    def set_day_count; self.day_count = 1 end
    def set_day_of_registration
      membership = Membership.find(self[:membership_id])
      self.day_of_registration = membership.first_date if membership.dailystats.present?
    end
      
end
