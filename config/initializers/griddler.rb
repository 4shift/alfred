# config/initializers/griddler.rb

Griddler.configure do |config|
  config.email_service = :mailgun
  config.processor_class = EmailProcessor
  config.processor_method = :process
  config.reply_delimiter = '-- REPLY ABOVE THIS LINE --'
end
