class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_authorization_check
  before_action :authorize!, only: [:edit, :destroy]

  layout "empty"

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)
    if @signup.valid?
      if MailgunService.new.create_domain(@signup.subdomain)
        Apartment::Tenant.create(@signup.subdomain)
        Apartment::Tenant.switch!(@signup.subdomain)
        @signup.save

        redirect_to new_user_session_url(subdomain: @signup.subdomain)
      end
    else
      render action: 'new'
    end
  end

  def edit
    @current_domain = request.host
  end

  def destroy
    current_account.destroy
    Apartment::Tenant.drop(current_domain)
  end

  private

  def signup_params
    params.require(:signup)
          .permit(:subdomain, :name, :email,
                  :password, :password_confirmation)
  end

  def authorize!
    raise ActiveRecord::RecordNotFound unless current_user_owner?
  end
end
