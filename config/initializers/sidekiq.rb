rails_env = ENV['RAILS_ENV'] || 'production'

env_num = rails_env == 'development' ? 1 : 0
Redis.new(db: env_num)

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://127.0.0.1:6379/#{env_num}", namespace: "clebee_#{rails_env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://127.0.0.1:6379/#{env_num}", namespace: "clebee_#{rails_env}" }
end
