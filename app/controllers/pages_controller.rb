class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  include HighVoltage::StaticPage

  layout "landing"
end
