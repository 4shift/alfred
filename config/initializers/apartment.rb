#require 'apartment/elevators/subdomain'
Apartment.configure do |config|
  config.excluded_models = %w{ Account }
  config.tenant_names = -> { Account.pluck :subdomain }
end
#Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'
Apartment::Elevators::Subdomain.excluded_subdomains = ['www', 'admin']
