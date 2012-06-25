class Account < ActiveRecord::Base
  has_many :members

  attr_accessible :realname, :uid, :username, :path, :gid, :gidname

  validates :username, presence:true, uniqueness:true
end
