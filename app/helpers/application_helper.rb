module ApplicationHelper

  def boolean_tag(boolean_value)
    char = boolean_value ? '✓' : '❌'
    css_class = "bool_#{boolean_value.to_s}"
    content_tag(:span, char, class: css_class, data: { tooltip: boolean_value ? 'Yes' : 'No' })
  end

  def date_tag(date)
    datetime_tag(date, format: '%a %b %d, %Y')
  end

  def datetime_tag(datetime, format: '%c')
    return '' if datetime.blank?

    formatted_datetime = datetime.strftime(format)

    content_tag(:span, "#{distance_of_time_in_words(datetime, Time.zone.now)} ago", class: "datetime", data: { tooltip: formatted_datetime})
  end

  # Creates a link to an external resource
  # Follows the Rails' link_to signature
  def external_link_to(name = nil, options = nil, html_options = {}, &block)
    default_html_options = { class: 'external', target: '_blank' }
    link_to(name, options, default_html_options.merge(html_options))
  end

  def icon_for_scope(scope_name)
    case scope_name.to_s
    when /address/
      'location-dot'
    when /beach_pass/
      'ticket'
    when /boat/
      'ship'
    when /border/
      'people-robbery'
    when /deed_holder/
      'gavel'
    when /dependent/
      'user-graduate'
    when /description/
      'clipboard'
    when /dinghy/
      'anchor'
    when /email/
      'at'
    when /fee/
      'sack-dollar'
    when /for_sale/
      'sign-hanging'
    when /future/, /time/
      'stopwatch'
    when /lot/
      'mountain-sun'
    when /membership_eligible/
      'umbrella-beach'
    when /name/
      'signature'
    when /number/
      'hashtag'
    when /property/, /primary_residence/
      'house-chimney'
    when /quantity/
      'buy-n-large'
    when /renter/
      'suitcase'
    when /resident_status/
      'tent'
    when /section/
      'section'
    when /significant_other/
      'user-group'
    when /size/
      'percent'
    when /state/
      'flag-usa'
    when /street/
      'road'
    when /sun/
      'sun'
    when /tag/, /vehicle/, /parking/
      'car'
    when /utility/
      'golf-ball-tee'
    when /verified/
      'certificate'
    when /watercraft/
      'warehouse'
    else
      raise NotImplementedError, "No icon for scope #{scope_name.inspect}"
    end
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
      font_awesome_icon(icon, caption: caption) + "&nbsp;".html_safe + message
    end
  end

  def list_delimiter
    content_tag(:span, '|', class: 'list-delimiter')
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

  def searchbar_tag(model, controller: model.name.tableize, show_filters: true)
    index_path = url_for(controller: controller, action: :index)
    content_tag(:div, class: "searchbar row") do
      concat(search_form_tag(index_path))
      if show_filters
        url_options = index_path
        concat "Filters:&nbsp;".html_safe
        concat link_to(
          " 😈",
          Addressable::URI.new(path: url_options, query_values: {q: 'Problematic'}).to_s,
          class: 'no-link-icon', data: { tooltip: "Show only 'problematic'" }
        )
        concat link_to(
          " 💸",
          Addressable::URI.new(path: url_options, query_values: {q: 'Not Paid'}).to_s,
          class: 'no-link-icon', data: { tooltip: "Show items 'Expecting a Payment'" }
        )
        concat link_to(
          " 🥵",
          url_options,
          class: 'no-link-icon', data: { tooltip: "Show ALL. ⚠️ Expect delays." }
        )
        concat "&nbsp;|&nbsp;".html_safe
        model.scopes.each do |scope_name|
          - tooltip = scope_name.to_s.humanize
          - icon_class = scope_name =~ /not|without/ ? 'not' : ''
          - icon = icon_for_scope(scope_name)
          search_path = url_for(controller: controller, action: :index, params: {q: scope_name})
          concat(link_to(search_path, class: 'search-filter no-link-icon', data: {tooltip: tooltip}) do
            font_awesome_icon(icon, html_options: {class: icon_class})
          end)
        end
      end
    end
  end

  def search_form_tag(url_options, html_options={})
    default_html_options = {
      class: 'search-form row',
      method: :get
    }
    default_html_options.merge!(html_options)

    form_tag(url_options, default_html_options) do
      concat label_tag(:q, 'Search')
      concat text_field_tag(:q, params[:q], class: 'search', type: 'search')
      concat submit_tag("Search")
      concat content_tag(:i, nil, class: 'search busy activated')
    end
  end

  def sort_models(models, sort_info)
    sort_column = sort_info[:column]
    sort_direction = sort_info[:direction]
    # models.order("#{sort_column} #{sort_direction}")

    # WORKAROUND: support sorting by non-AR columns
    # Yes, this is inefficient but our lists are small
    # Using format(), with leading zeros, to support sorting string, number, or TrueClass
    models = models.sort_by{|r| format('%010s' % r.send(sort_column).to_s)}
    if sort_direction.to_s != 'asc'
      models = models.reverse
    end
    models
  end
end
