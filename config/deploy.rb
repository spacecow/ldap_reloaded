require 'bundler/capistrano'
require "whenever/capistrano"

server "virgo.dmz.riec.tohoku.ac.jp", :web, :app, :db, primary:true

set :user, "jsveholm"
set :application, "ldap_reloaded"
set :deploy_to, "/home/jsveholm/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:spacecow/ldap_reloaded.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"

#set :admin_runner, "jsveholm"
#
#set :default_environment, { 
#  'PATH' => "/opt/local/csw/bin:/opt/local/bin:/opt/csw/bin:/usr/bin:/usr/local/bin"
#}

after "deploy", "deploy:cleanup" #keep only the last 5 releases

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/reports #{release_path}/private/reports"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared' #, "delayed_job:restart"
