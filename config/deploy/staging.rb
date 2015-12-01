set :deploy_to, '/srv/repository/www/alfred_staging'
set :branch, 'staging'
set :rails_env, 'staging'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :unicorn_env, "staging"
