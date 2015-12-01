module BounceHelper
  def bounced?(mail)
    return true if !mail.headers['Return-Path'].nil? && mail.headers['Return-Path'].value == ''
    false
  end
end
