class Account < ActiveRecord::Base
  has_many :members

  attr_accessor :path, :gid, :gidname
  attr_accessible :realname, :uid, :username, :path, :gid, :gidname
  before_save :create_member

  validates :username, presence:true, uniqueness:true

  def create_member(gid = @gid)
    members << Member.create(path:@path, gid:gid, gidname:@gidname)
  end
end
