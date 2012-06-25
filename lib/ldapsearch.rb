class Ldapsearch
  class << self
    def group_hash(file = 'ldap_info.txt')
      """ 
      Creates a hash with gid number as key and the group name as the value.
      """ 
      group, hash, cn = false, {}, ""
      File.open("data/#{file}").each do |line|
        group = true if line.match(/ou=group/)
        group = false if line == "\n"
        if group
          if data = line.match(/cn: (\w+)/)
            cn = data[1]
          end
          if data = line.match(/gidNumber: (\d+)/)
            hash[data[1]] = cn
          end
        end
      end
      return hash
    end

    def find_or_create_accounts_and_memberships(group_hash, file = "ldap_info.txt")
      people, hash, memberships = false, {}, []
      File.open("data/#{file}").each do |line|
        if people_match(line) 
          people = true 
          hash = {}
        end 
        if people and line == "\n"
          people = false 
          account = Account.find_or_create(hash[:username], hash[:uid], hash[:realname])
          #group = Group.create(gid:hash[:gid], gidname:hash[:gidname])
          membership = Membership.create(path:hash[:path], gid:hash[:gid], gidname:hash[:gidname], account_id:account.id)
          if membership.valid?
            memberships << membership 
          elsif account.memberships.present?
            memberships << account.memberships.find_by_gid(hash[:gid]) 
          end
        end
        if people
          if data = line.match(/gidNumber: (\d+)/)
            hash[:gid] = data[1]
            hash[:gidname] = group_hash[data[1]]
          end
          if data = line.match(/homeDirectory: (.*)/)
            hash[:path] = data[1]
          end
          if data = line.match(/uid: (.*)/)
            hash[:username] = data[1]
          end
          if data = line.match(/uidNumber: (.*)/)
            hash[:uid] = data[1]
          end
          if data = line.match(/gecos: (.*)/)
            hash[:realname] = data[1]
          end
        end
      end #File.open
      memberships
    end #read

    def people_match(line); line.match(/ou=\"?people\"?/i) end
  end
end
