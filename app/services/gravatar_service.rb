class GravatarService
  def execute(email, size = nil)
    if gravatar_config.enabled && email.present?
      size = 40 if size.nil? || size <= 0

      default_url = "#{voc_config.url}/assets/avatars/1.jpg"
      sprintf gravatar_url,
              hash: Digest::MD5.hexdigest(email.strip.downcase),
              size: size,
              default_url: CGI.escape(default_url),
              email: email.strip
    end
  end

  def voc_config
    Voc.config.voc
  end

  def gravatar_config
    Voc.config.gravatar
  end

  def gravatar_url
    if voc_config.https
      gravatar_config.ssl_url
    else
      gravatar_config.plain_url
    end
  end
end
