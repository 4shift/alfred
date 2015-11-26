module Alfred
  def self.google_analytics_id
    ENV["GOOGLE_ANALYTICS_KEY"]
  end

  def self.single_tenant_mode?
    ENV["SINGLE_TENANT_MODE"] == "true" ? true : false
  end

  def self.cache_id
    @@cache_id ||= Time.current.to_s
  end
end
