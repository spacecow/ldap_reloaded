class Membership < ActiveRecord::Base
  belongs_to :account

  has_many :dailystats
  has_many :days, :through => :dailystats

  attr_accessible :gid, :gidname, :path, :account_id

  validates :gid, presence:true
  validates_uniqueness_of :gid,  :scope => :account_id
end
