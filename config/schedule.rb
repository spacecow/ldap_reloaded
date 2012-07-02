set :output, "#{path}/log/cron.log"

every 1.day, :at => '2:00am' do
  rake "generate_todays_userlist"
end
