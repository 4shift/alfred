devise_for :users
mount_griddler

namespace :tickets do
  resource :deleted, only: :destroy, controller: :deleted
  resource :selected, only: :update, controller: :selected
end

resources :tickets, except: [:destroy, :edit] do
  resource :lock, only: [:destroy, :create], module: :tickets
end

resources :labelings, only: [:destroy, :create]
resources :rules
resources :labels, only: [:destroy, :update, :index, :edit]
resources :replies, only: [:create, :new, :update, :show]

get '/attachments/:id/:format' => 'attachments#show'

resources :attachments, only: [:index, :new]
resources :email_addresses
resources :settings, only: [:edit, :update]

namespace :api do
  namespace :v1 do
    resources :tickets, only: [:index, :show]
    resources :sessions, only: [:create]
  end
end

resources :conversations do
  resources :messages
end

resources :lists do
  collection do
    get 'users'
    get 'datatables'
    get 'products'
  end
end

resources :reports do
  collection do
    get 'orders'
    get 'sales'
  end
end

resources :forms do
  collection do
    get 'new_customer'
    get 'new_product'
    get 'wizard'
  end
end

resources :pages do
  collection do
    get 'inbox'
    get 'profile'
    get 'latest_activity'
    get 'projects'
    get 'steps'
    get 'calendar'
  end
end

resources :pricing do
  collection do
    get 'plans'
    get 'charts'
    get 'form'
    get 'invoice'
  end
end

resources :features do
  collection do
    get 'email_templates'
    get 'gallery'
    get 'ui'
    get 'api'
    get 'signup'
    get 'signin'
    get 'status'
  end
end

resources :account do
  collection do
    get 'settings'
    get 'billing'
    get 'notifications'
    get 'support'
  end
end
