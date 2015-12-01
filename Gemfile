source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Auth
gem 'devise', '~> 3.4.0'   # or later
gem 'devise-async', '0.9.0'
gem 'omniauth', '~> 1.1.3'
gem 'omniauth-facebook'

# Email Processing
gem 'griddler', '~> 1.0.0'
gem 'griddler-mailgun', '~> 1.0.1'

# Authorization
gem 'cancancan'
# Allow cors
gem 'rack-cors', :require => 'rack/cors'
# Multi tenant
gem 'apartment'
gem 'high_voltage', '~> 2.4.0'
gem 'simple_form'
gem 'haml', '~> 4.0.5'

# non-digested assets for brimir-plugin js/css
gem 'non-stupid-digest-assets'

# Useful Javascript with rails
gem 'gon', '~> 5.0.0'
gem 'remotipart', '~> 1.2'
gem 'modernizr-rails'
gem 'rest-client'

# faye
gem 'private_pub'
gem 'thin'

# Background jobs
gem 'sidekiq', '~> 3.3'
gem 'sinatra', require: false
gem 'slim'

# Settings
gem 'settingslogic'

# attachments, thumbnails etc
gem 'paperclip'

# non-digested assets for
gem 'non-stupid-digest-assets'

# etc
gem 'will_paginate', '~> 3.0.5'
# for language detection
gem 'http_accept_language'
# detect browser
gem "browser"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'annotate', '~> 2.6.0.beta2'
  gem 'better_errors'
  gem 'meta_request'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'foreman'
  gem "pry"
end

group :development, :test do
  gem "dotenv-rails"
  gem 'rspec-rails', '~> 3.0'
  gem 'pry-rails'

  # Generate Fake data
  gem 'ffaker'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem "newrelic_rpm", ">= 3.7.3"
  gem "rails_12factor"
end

gem 'mina'
gem 'mina-sidekiq', :require => false
gem 'mina-unicorn', :require => false
gem 'mina-multistage', :require => false
