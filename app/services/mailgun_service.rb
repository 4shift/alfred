class MailgunService

  def create_routes(domain)
    response = RestClient::Request.execute(
      :url => "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v3/routes",
      :method => :post,
      :payload => {
        :priority => 0,
        :description => "Routes for #{domain}",
        :expression => "match_recipient('tickets@#{domain}.4shift.com')",
        :action => "forward('http://#{domain}.4shift.com/email_processor/')"
      }
    )
  end

  def create_domain(domain)
    response = RestClient::Request.execute(
      :url => "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v3/domains",
      :method => :post,
      :payload => {
        :name => "#{domain}.4shift.com",
        :smtp_password => random_password
      }
    )
  end

  private

  def random_password
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...20).map { o[rand(o.length)] }.join
  end

end
