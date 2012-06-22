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

    def read(group_hash, file = "ldap_info.txt")
      people, hash = false, {}
      File.open("data/#{file}").each do |line|
        if people_match(line) 
          people = true 
          hash = {}
        end 
        if people and line == "\n"
          people = false 
          if Account.exists?(username:hash[:username])
            Account.find_by_username(hash[:username]).create_member(hash[:gid]) 
          else
            Account.create(path:hash[:path], gid:hash[:gid], gidname:hash[:gidname], username:hash[:username], uid:hash[:uid], realname:hash[:realname])
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
      end
    end #read

    def people_match(line); line.match(/ou=\"?people\"?/i) end
  end
end
