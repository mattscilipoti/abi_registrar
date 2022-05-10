module ApplicationHelper

  def datetime_tag(datetime)
    content_tag(:span, "#{time_ago_in_words(datetime)} ago", class: "datetime", data: { tooltip: datetime.rfc2822})
  end

  def flash_icon_name(flash_type)
    case flash_type.to_sym
    when :alert
      'triangle-exclamation'
    when :notice
      'circle-info'
    when :success
      'square-check'
    else
      raise ArgumentError, "Unsupported flash_type (#{flash_type})"
    end
  end

  def flash_tag(flash_type, message, caption: nil)
    content_tag(:div, :class => "flash highlight #{flash_type}") do
      icon = flash_icon_name(flash_type)
      font_awesome_icon(icon, caption: caption) + message
    end
  end

  def menu_list_item(caption, url_options, html_options={})
    default_css_classes = []
    default_css_classes << 'is-active' if current_page?(url_options)
    default_html_options = { class: default_css_classes}
    content_tag(:li, default_html_options) do
      link_to caption, url_options, html_options
    end
  end

  def number_with_percentage(number, total)
    percentage = (number.to_f / total.to_f) * 100
    content_tag(:span) do
      concat number
      concat content_tag(:small, " (#{percentage.round(1)}%)", class: 'percentage')
    end
  end


  def search_form_tag(url_options, html_options={})
    default_html_options = {
      class: 'search-form',
      method: :get
    }
    default_html_options.merge!(html_options)
    form_tag(url_options, default_html_options) do
      concat label_tag(:q, 'Search')
      concat text_field_tag(:q, params[:q], class: 'search')
      concat submit_tag("Search")
    end
  end
end
