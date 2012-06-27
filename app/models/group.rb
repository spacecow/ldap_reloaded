class Group < ActiveRecord::Base
  has_many :memberships
  has_many :accounts, :through => :memberships

  attr_accessible :gid, :gidname

  validates :gid, presence:true, uniqueness:true

  class << self
    def find_or_create(gid, gidname)
      if Group.exists?(gid:gid)
        group = Group.find_by_gid(gid)
      else
        group = Group.create(gid:gid, gidname:gidname)
      end
    end
  end
end
