set :deploy_to, '/srv/repository/www/4shift'
set :branch, 'master'
set :rails_env, 'production'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :unicorn_env, "production"
