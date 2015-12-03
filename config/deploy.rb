set :default_stage, 'production'

require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina_sidekiq/tasks'
require 'mina/unicorn'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :term_mode, nil
set :domain, '182.161.126.8'
set :repository, 'git@github.com:4shift/alfred.git'
set :user, 'deploy'
set :forward_agent, true
set :port, '22'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'


# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, [
                     'config/database.yml',
                     'log',
                     'config/secrets.yml',
                     'config/local_env.yml',
                     'public/system',
                     'data'
                 ]

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  queue %{
echo "-----> Loading environment"
#{echo_cmd %[source ~/.bashrc]}
        }
  invoke :'rbenv:load'
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
end


# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/local_env.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/local_env.yml'."]

  # carrierwave needs a place to store its data
  queue! %[mkdir -p "#{deploy_to}/shared/data"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/data"]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do

     #stop accepting new workers
    #invoke :'sidekiq:quiet'

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      #invoke :'sidekiq:restart'
      invoke :'unicorn:restart'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
