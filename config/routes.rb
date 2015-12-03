require 'alfred'

class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(
      Rails.root.join("config/routes/#{routes_name}.rb")
    ))
  end
end

class SubdomainPresent
  def self.matches?(request)
    request.subdomain.present?
  end
end

class SubdomainBlank
  def self.matches?(request)
    request.subdomain.blank?
  end
end

Rails.application.routes.draw do

  if Alfred.single_tenant_mode?
    root "tickets#index"
    draw :subdomain_present
    draw :subdomain_blank
  else
    constraints(SubdomainPresent) do
      root "home#index", as: :subdomain_root
      draw :subdomain_present
    end

    constraints(SubdomainBlank) do
      root to: "pages#show", id: "landing"
      draw :subdomain_blank
    end
  end
end
