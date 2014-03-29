# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'sinkohippa'
set :repo_url, 'git@github.com:OsQu/sinkohippa.git'
set :branch, 'master'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/sinkohippa'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

require 'json'

namespace :deploy do

  desc "Create log directory"
  task :log_dir do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{release_path}/server" do
        execute(:mkdir, "-p", "production")
      end
    end
  end


  desc 'Restart application'
  task :restart => :log_dir do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{release_path}/server" do
        execute(:forever, 'stopall') rescue
        execute(:sh, 'start.sh')
      end
    end
  end

  desc "Add npm dependencies"
  task :npm_dependencies do
    on roles(:app) do
      within "#{release_path}/server" do
        execute(:npm, "install",  "--silent")
      end

      within "#{release_path}/client" do
        execute(:npm, "install", "--silent")
      end
    end
  end

  desc "Configure client environment"
  task :configure_env do
    on roles(:app) do |server|
      within "#{release_path}/client/app" do
        env = { server_url: "http://#{server.hostname}:#{server.properties.websocket_port}" }
        upload!(StringIO.new(JSON.dump(env)), "#{release_path}/client/app/env.json")
      end
    end
  end

  desc "Build client"
  task :build_client => :configure_env do
    on roles(:app) do
      within "#{release_path}/client" do
        execute(:grunt, "build")
      end
    end
  end

  after :updated, :npm_dependencies
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
