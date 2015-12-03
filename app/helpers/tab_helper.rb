module TabHelper
  # Navigation link helper
  #
  # Returns an `li` element with an 'active' class if the supplied
  # controller(s) and/or action(s) are currently active. The content of the
  # element is the value passed to the block.
  #
  # options - The options hash used to determine if the element is "active" (default: {})
  #           :controller   - One or more controller names to check (optional).
  #           :action       - One or more action names to check (optional).
  #           :path         - A shorthand path, such as 'dashboard#index', to check (optional).
  #           :html_options - Extra options to be passed to the list element (optional).
  # block   - An optional block that will become the contents of the returned
  #           `li` element.
  #
  # When both :controller and :action are specified, BOTH must match in order
  # to be marked as active. When only one is given, either can match.
  #
  # Examples
  #
  #   # Assuming we're on TreeController#show
  #
  #   # Controller matches, but action doesn't
  #   nav_link(controller: [:tree, :refs], action: :edit) { "Hello" }
  #   # => '<li>Hello</li>'
  #
  #   # Controller matches
  #   nav_link(controller: [:tree, :refs]) { "Hello" }
  #   # => '<li class="active">Hello</li>'
  #
  #   # Several paths
  #   nav_link(path: ['tree#show', 'profile#show']) { "Hello" }
  #   # => '<li class="active">Hello</li>'
  #
  #   # Shorthand path
  #   nav_link(path: 'tree#show') { "Hello" }
  #   # => '<li class="active">Hello</li>'
  #   # Shorthand path with param
  #   nav_link(path: 'tree#show') { "Hello" }
  #   # tree => controller, show => param[:id]
  #   # => '<li class="active">Hello</li>'
  #
  #   # Supplying custom options for the list element
  #   nav_link(controller: :tree, html_options: {class: 'home'}) { "Hello" }
  #   # => '<li class="home active">Hello</li>'
  #
  # Returns a list item element String

  def nav_link(options = {}, &block)
    klass = active_nav_link?(options) ? 'active' : ''

    o = options.delete(:html_options) || {}
    o[:class] ||= ''
    o[:class] += ' ' + klass
    o[:class].strip!

    if block_given?
      content_tag(:li, capture(&block), o)
    else
      content_tag(:li, nil, o)
    end
  end

  def active_nav_link?(options)
    if path = options.delete(:path)
      unless path.respond_to?(:each)
        path = [path]
      end

      path.any? do |single_path|
        current_path?(single_path)
      end
    elsif param = options.delete(:param)
      unless param.respond_to?(:each)
        param = [param]
      end

      param.any? do |single_param|
        current_path_with_param?(single_param)
      end
    else
      c = options.delete(:controller)
      a = options.delete(:action)

      if c && a
        current_controller?(*c) && current_action?(*a)
      else
        current_controller?(*c) || current_action?(*a)
      end
    end
  end

  def current_path?(path)
    c, a, _ = path.split('#')
    current_controller?(c) && current_action?(a)
  end

  def current_path_with_param?(path)
    c, p, _ = path.split('#')
    current_controller?(c) && current_param?(p)
  end

  def nav_tab(key, value, &block)
    o = {}
    o[:class] = ""

    if value.nil?
      o[:class] << " active" if params[key].blank?
    else
      o[:class] << " active" if params[key] == value
    end

    if block_given?
      content_tag(:li, capture(&block), o)
    else
      content_tag(:li, nil, o)
    end
  end
end
