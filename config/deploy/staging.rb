set :deploy_to, '/srv/repository/www/4shift_staging'
set :branch, 'staging'
set :rails_env, 'staging'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :unicorn_env, "staging"
