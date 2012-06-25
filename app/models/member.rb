class Member < ActiveRecord::Base
  belongs_to :account
  attr_accessible :gid, :gidname, :path, :account_id

  validates :gid, presence:true
  validates_uniqueness_of :gid,  :scope => :account_id
end
