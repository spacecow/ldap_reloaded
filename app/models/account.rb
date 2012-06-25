class Account < ActiveRecord::Base
  has_many :members

  attr_accessible :realname, :uid, :username, :path, :gid, :gidname

  validates :username, presence:true, uniqueness:true

  class << self
    def find_or_create(username, uid, realname)
      if Account.exists?(username:username)
        account = Account.find_by_username(username)
      else
        account = Account.create(username:username, uid:uid, realname:realname)
      end
    end
  end
end
