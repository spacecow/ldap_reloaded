task :generate_todays_userlist => :environment do
  Day.generate_todays_userlist
end
