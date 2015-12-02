class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  include HighVoltage::StaticPage

  before_action :prepare_signup

  layout "landing"

  private

  def prepare_signup
    @signup = Signup.new
  end
end
