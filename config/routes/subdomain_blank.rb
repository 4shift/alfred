#get "/pages/*id" => "pages#show", as: :page, format: false
post "accounts/verify_email", to: "accounts#verify_email"
get "accounts/confirm_email", to: "accounts#confirm_email"

resource :accounts, only: [:new, :create]
