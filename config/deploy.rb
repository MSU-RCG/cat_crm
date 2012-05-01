$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"

set :rvm_ruby_string, 'ruby-1.9.2-p180@passenger'
set :application, "catsrm-nursing"
set :branch, "master"
set :deploy_via, :remote_cache

set :scm, :git
set :repository,  "git://github.com/MSU-RCG/cat_crm.git"

role :web, "catsrm-nursing.rcg.montana.edu"
role :app, "catsrm-nursing.rcg.montana.edu"
role :db,  "catsrm-nursing.rcg.montana.edu", :primary => true

set :use_sudo, false
set :user, "rails"
set :deploy_to, "/var/rails"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

set :links, {
  # add files here you want to symlink from shared/*
  :files => %w{
    config/database.yml
  },
  # add dirs here you want to symlink from shared/*
  :dirs => %w{
  }
}

namespace :rails do
  namespace :db do
    task :setup do
      run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake db:setup"
    end

    task :autoupgrade do
      run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
    end
  end
  
  namespace :symlink do
    task :setup do
      links[:dirs].each do |l|
        run "mkdir -p #{deploy_to}/#{shared_dir}/#{l}"
      end
    end

    task :link do
      (links[:files] + links[:dirs]).each do |l|
        run "ln -nfs #{deploy_to}/#{shared_dir}/#{l} #{release_path}/#{l}"
      end
    end
  end
end

after "deploy:setup",       "rails:symlink:setup"
after "deploy:symlink",     "rails:symlink:link"
after "deploy",             "rails:db:migrate"