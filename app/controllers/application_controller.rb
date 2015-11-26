class ApplicationController < ActionController::Base

  protect_from_forgery with: :reset_session
  before_action :load_schema, unless: -> { Alfred.single_tenant_mode? }
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :load_labels, if: :user_signed_in?
  before_action :set_locale

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if Rails.env == :production
      redirect_to root_url, alert: exception.message
    else
      render text: exception, status: :unauthorized
    end
  end

  protected

  def load_locales
    @time_zones = ActiveSupport::TimeZone.all.map(&:name).sort
    @locales = []

    Dir.open("#{Rails.root}/config/locales").each do |file|
      unless ['.', '..'].include?(file)
        code = file[0...-4]
        @locales << [I18n.translate(:language_name, locale: code), code]
      end
    end
  end

  def load_labels
    @labels = Label.viewable_by(current_user).ordered
  end

  def generate_channel
    Devise.friendly_token
  end

  def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :owner, :subdomain, :password, :password_confirmation) }
  end

  private

  helper_method :current_subdomain, :current_user_owner?

  def current_subdomain
    @current_subdomain ||= current_user.subdomain unless Alfred.sing_tenant_mode?
  end

  def current_user_owner?
    current_account.owner == current_user unless Alfred.single_tenant_mode?
  end

  def current_account
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end

  def load_schema
    Apartment::Tenant.switch!("public")
    return unless request.subdomain.present?

    if current_account
      Apartment::Tenant.switch!(request.subdomain)
    else
      redirect_to root_url(subdomain: false)
    end
  end

  def set_locale
    I18n.locale =
      http_accept_language.compatible_language_from(I18n.available_locales)
  end

end
