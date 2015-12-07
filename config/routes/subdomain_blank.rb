#get "/pages/*id" => "pages#show", as: :page, format: false
post "accounts/verify_email", to: "accounts#verify_email"
resource :accounts, only: [:new, :create]
