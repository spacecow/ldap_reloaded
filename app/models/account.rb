class Account < ActiveRecord::Base
  has_many :memberships
  has_many :groups, :through => :memberships

  attr_accessible :realname, :uid, :username, :path, :gid, :gidname

  validates :username, presence:true, uniqueness:true

  def realname
    a = self[:realname].split(',')
    "#{a[-1].lstrip} #{a[0]}"
  end

  def realname=(s)
    unless s.nil?
      a = s.split
      self[:realname] = "#{a[-1]}, #{a[0..-2].join(' ')}"
    end
  end

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
