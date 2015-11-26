class ClientEvent
  MONITORED_CHANNELS = ['/meta/subscribe', '/meta/disconnect']

  def incoming(message, callback)
    puts message.inspect
    return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']

    faye_client.publish('/public/managed', { 'message' })
    callback.call(message)
  end

  def faye_client
    @faye_client ||= Faye::Client.new('http://localhost:9292/faye')
  end
end
