class Member < ActiveRecord::Base
  belongs_to :account
  attr_accessible :gid, :gidname, :path, :user_id

  validates :gid, presence:true, uniqueness:true
end
