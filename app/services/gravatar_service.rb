class GravatarService
  def execute(email, size = nil)
    if gravatar_config.enabled && email.present?
      size = 40 if size.nil? || size <= 0

      sprintf gravatar_url,
              hash: Digest::MD5.hexdigest(email.strip.downcase),
              size: size,
              default_url: "https://www.clebee.net/assets/no_avatar.jpg",
              email: email.strip
    end
  end

  def alfred_config
    Alfred.config.alfred
  end

  def gravatar_config
    Alfred.config.gravatar
  end

  def gravatar_url
    if alfred_config.https
      gravatar_config.ssl_url
    else
      gravatar_config.plain_url
    end
  end
end
