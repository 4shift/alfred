class MailgunService

  def send_message
    response = RestClient::Request.execute(
      :url => messaging_api_end_point,
      :method => :post,
      :payload => {
        :to => "wecanooo@gmail.com",
        :from => "wecanooo@4shift.com",
        :subject => "Hello from Ruby!",
        :text => "Sent via mailgun"
      }
    )
  end

  def create_domain(domain, create_mailbox = true)
    response = RestClient::Request.execute(
      :url => routing_api_end_point,
      :method => :post,
      :payload => {
        :priority => 0,
        :description => "Routes for #{domain}",
        :expression => "match_recipient('#{domain}@4shift.com')",
        :action => "forward('https://#{domain}.4shift.com/email_processor/')"
      }
    )

    create_mailbox(domain) if create_mailbox
  end

  def create_mailbox(mailbox_name)
    response = RestClient::Request.execute(
      :url => mailbox_api_end_point,
      :method => :post,
      :payload => {
        :mailbox => "#{mailbox_name}@#{api_domain}",
        :password => "#{random_password}"
      }
    )
  end

  private

  def api_key
    @api_key ||= ENV["MAILGUN_API_KEY"]
  end

  def api_domain
    @api_domain ||= ENV["MAILGUN_API_DOMAIN"]
  end

  def messaging_api_end_point
    @messaging_api_end_point ||= "https://api:#{api_key}@api.mailgun.net/v3/#{api_domain}/messages"
    Rails.logger.debug @messaging_api_end_point
  end

  def routing_api_end_point
    @routing_api_end_point ||= "https://api:#{api_key}@api.mailgun.net/v3/routes"
    Rails.logger.debug @routing_api_end_point
  end

  def mailbox_api_end_point
    @mailbox_api_end_point ||= "https://api:#{api_key}@api.mailgun.net/v3/#{api_domain}/mailboxes"
    Rails.logger.debug @mailbox_api_end_point
  end

  def random_password
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...20).map { o[rand(o.length)] }.join
  end

end
