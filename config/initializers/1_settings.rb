class Settings < Settingslogic
  source "#{Rails.root}/config/voc.yml"
  namespace Rails.env

  class << self

    def voc_on_standard_port?
      voc.port.to_i == (voc.https ? 443 : 80)
    end

    def build_voc_url
      custom_port = voc_on_standard_port? ? nil : ":#{voc.port}"
      [ voc.protocol,
        "://",
        voc.host,
        custom_port,
        voc.relative_url_root
      ].join('')
    end

  end

end

# Global Settings
Settings['voc'] ||= Settingslogic.new({})
Settings.voc['host']            ||= Settings.voc.host
Settings.voc['https']             = false if Settings.voc['https'].nil?
Settings.voc['port']            ||= Settings.voc.https ? 443 : 80
Settings.voc['relative_url_root'] ||= ENV['RAILS_RELATIVE_URL_ROOT'] || ''
Settings.voc['protocol']        ||= Settings.voc.https ? "https" : "http"
Settings.voc['url']             ||= Settings.send(:build_voc_url)
Settings.voc['max_attachment_size'] ||= 10

# Gravatar Settings
Settings['gravatar'] ||= Settings.new({})
Settings.gravatar['enabled']      = true if Settings.gravatar['enabled'].nil?
Settings.gravatar['plain_url']  ||= 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=%{default_url}'
Settings.gravatar['ssl_url']    ||= 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=%{default_url}'

# Outgoing emails
Settings['outgoing_emails'] ||= Settingslogic.new({})
Settings['outgoing_emails'].tap do |opts|
  opts['enabled'] ||= Settings.voc['email_enabled']
  opts['from'] ||= Settings.voc['email_from']
  opts['display_name'] ||= Settings.voc['display_name']
  opts['reply_to'] ||= Settings.voc['email_reply_to']

  opts['enabled'] ||= opts['enabled'].nil?
  opts['display_name'] ||= "마음의 소리"
  opts['from'] ||= "webmaster@#{Settings.voc.host}"
  opts['reply_to'] ||= "noreply@#{Settings.voc.host}"
  opts['delivery_method'] ||= :sendmail
  opts['sendmail_settings'] ||= {}
  opts['smtp_settings'] ||= {}
end
