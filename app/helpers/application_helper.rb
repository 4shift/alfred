module ApplicationHelper
  def avatar_icon(user_email = '', size = nil)
    user = User.find_by(email: user_email)

    if user.avatar?
      user.avatar_url(size) || default_avatar
    else
      gravatar_icon(user_email, size)
    end
  end

  def gravatar_icon(user_email = '', size = nil)
    GravatarService.new.execute(user_email, size) || default_avatar
  end

  def time_ago_with_tooltip(time, placement: 'top', html_class: 'time_ago', skip_js: false)
    element = content_tag :time, time.to_s, class: "#{html_class} js-timeago",
                          datetime: time.getutc.iso8601, title: localize(time, :format => :long),
                          data: { toggle: 'tooltip', placement: placement }

    element += javascript_tag "$('.js-timeago').timeago()" unless skip_js
    element
  end

  def status_icon(status)
    if status == 'closed'
      'check-square-o'
    elsif status == 'deleted'
      'trash-o'
    elsif status == 'waiting'
      'clock-o'
    else
      'inbox'
    end
  end

  def nl2br(s)
    s.gsub(/\n/, '<br />').html_safe
  end

  def split_username(email)
    email.split('@')[0]
  end

  def get_agent_os
    os = 'Unknown'

    if browser.ios?
      os = 'iOS'
    elsif browser.mac?
      os = 'Mac'
    elsif browser.windows_x64?
      os = 'Windows x64'
    elsif browser.windows?
      os = 'Windows x86'
    elsif browser.linux?
      os = 'Linux'
    elsif browser.android?
      os = 'Android'
    else
      os = 'Unknown'
    end

    os
  end

end
