module HtmlTextHelper
  def strip_inline_style(content)
    content.to_s.gsub(/<style[^>]*>[^<]*<\/style>/, '')
  end

  def html_to_text(content)
    content = sanitize_html(content).gsub(%r{(<br ?/?>|</p>)}, "\n")
    CGI.unescapeHTML(sanitize(content, tags: []).to_str) # to_str for Rails #12672
  end

  def text_to_html(content)
    CGI.escapeHTML(content).gsub("\n", '<br />')
  end

  def sanitize_html(content)
    # strip inline style tags completely
    sanitize(
        strip_inline_style(content),
        tags:       %w( a b br code div em i img li ol p pre table td tfoot
                        thead tr span strong ul font ),
        attributes: %w( src href style color )
    ).html_safe
  end

  def wrap_and_quote(content)
    content = html_to_text(content)
    content = content.gsub(/^.*\n>.*$/, '') # strip off last line before older quotes
    content = content.gsub(/^>.*$/, '') # strip off older quotes
    content = word_wrap(content.strip, line_width: 72)
    content.gsub(/^/, '> ')
  end
end
