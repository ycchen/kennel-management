set :application, "Kennel Management"
set :repository,  "git@github.com:ycchen/kennel-management.git"
set :deploy_to, "/webapps/mgt.hungkwang.com"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :branch, 'master'
set :user, 'root'
set :rails_env, 'production'
set :deploy_via, :copy
set :ssh_options, {:forward_agent => true, :port => 22}
set :keep_releases, 5

default_run_options[:pty] = true

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

server "162.243.251.153", :app, :web, :db, :primary => true
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Symlink shared config files"
  task :symlink_config_files do
    run "#{ sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
  end

  # desc "Symlinks the database.yml"
  # task :symlink_db, :roles => :app do
  #   run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  # end

  # NOTE: I don't use this anymore, but this is how I used to do it.
  desc "Precompile assets after deploy"
  task :precompile_assets do
    run <<-CMD
      cd #{ current_path } &&
      #{ sudo } bundle exec rake assets:precompile RAILS_ENV=#{ rails_env }
    CMD
  end

  
  desc "Symlink shared/uploads folder for file uploads"
  task :symlink_directories do
    run "rm -Rf #{release_path}/public/uploads"
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc "Restart applicaiton"
  task :restart do
    run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end

end

namespace :bundle do
  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install" 
  end
end

before "deploy:restart", "bundle:install"
after  "deploy", "deploy:symlink_config_files"
after  "deploy", "deploy:symlink_directories"
# after  "deploy", "deploy:precompile_assets"
after  "deploy", "deploy:restart"
after  "deploy", "deploy:cleanup"

