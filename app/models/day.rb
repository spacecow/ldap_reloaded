class Day < ActiveRecord::Base
  attr_accessible :date, :users_count

  validates :date, uniqueness:true

  class << self
    def generate_userlist(date_s)
      raise DayExistsException if Day.exists?(date:date_s)
      Day.create(date:date_s)
    end
  end
end
