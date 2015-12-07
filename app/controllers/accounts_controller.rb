class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :verify_email, :confirm_email]
  skip_authorization_check
  before_action :authorize!, only: [:edit, :destroy]

  layout "empty"

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)
    if @signup.valid?
      if MailgunService.new.create_domain(@signup.subdomain) && MailgunService.new.create_routes(@signup.subdomain)
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

  def verify_email
    username = params[:username]
    email = params[:email]

    if username.nil? || email.nil?
      flash[:alert] = t('invalid_request')
      redirect_to root_path and return
    end

    respond_to do |format|
      NotificationMailer.activation_email(username, email).deliver_now
      format.html { redirect_to root_path }
      format.json { render json: { message: "success" } }
    end
  end

  def confirm_email
    unless params[:token].present?
      flash[:alert] = t('invalid_token')
      redirect_to root_url and return
    end

    token = params[:token] if params[:token].present?
    decrypted_data = AesEncrypt.decryption(token)
    username, email = decrypted_data.split('.')

    @signup = Signup.new
    @signup.name = username
    @signup.email = email

    respond_to do |format|
      format.html
    end
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
