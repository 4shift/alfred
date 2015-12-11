class Settings < Settingslogic
  source "#{Rails.root}/config/alfred.yml"
  namespace Rails.env

  class << self

    def alfred_on_standard_port?
      alfred.port.to_i == (alfred.https ? 443 : 80)
    end

    def build_alfred_url
      custom_port = alfred_on_standard_port? ? nil : ":#{alfred.port}"
      [ alfred.protocol,
        "://",
        alfred.host,
        custom_port,
        alfred.relative_url_root
      ].join('')
    end

  end

end

# Global Settings
Settings['alfred'] ||= Settingslogic.new({})
Settings.alfred['host']            ||= Settings.alfred.host
Settings.alfred['https']             = false if Settings.alfred['https'].nil?
Settings.alfred['port']            ||= Settings.alfred.https ? 443 : 80
Settings.alfred['relative_url_root'] ||= ENV['RAILS_RELATIVE_URL_ROOT'] || ''
Settings.alfred['protocol']        ||= Settings.alfred.https ? "https" : "http"
Settings.alfred['url']             ||= Settings.send(:build_alfred_url)
Settings.alfred['max_attachment_size'] ||= 10

# Gravatar Settings
Settings['gravatar'] ||= Settings.new({})
Settings.gravatar['enabled']      = true if Settings.gravatar['enabled'].nil?
Settings.gravatar['plain_url']  ||= 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=%{default_url}'
Settings.gravatar['ssl_url']    ||= 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=%{default_url}'

# Outgoing emails
Settings['outgoing_emails'] ||= Settingslogic.new({})
Settings['outgoing_emails'].tap do |opts|
  opts['enabled'] ||= Settings.alfred['email_enabled']
  opts['from'] ||= Settings.alfred['email_from']
  opts['display_name'] ||= Settings.alfred['display_name']
  opts['reply_to'] ||= Settings.alfred['email_reply_to']

  opts['enabled'] ||= opts['enabled'].nil?
  opts['display_name'] ||= "마음의 소리"
  opts['from'] ||= "webmaster@#{Settings.alfred.host}"
  opts['reply_to'] ||= "noreply@#{Settings.alfred.host}"
  opts['delivery_method'] ||= :sendmail
  opts['sendmail_settings'] ||= {}
  opts['smtp_settings'] ||= {}
end
