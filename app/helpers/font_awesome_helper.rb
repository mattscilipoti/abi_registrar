module FontAwesomeHelper
  IconTypeAbbreviations = {
    brand: :fab,
    duotone: :fad,
    light: :fal,
    regular: :far,
    solid: :fas,
    uploaded: :fak
  }

  def font_awesome_icon(icon_name, accessible_label: nil, caption: nil, icon_type: :solid, html_options: {})
    image_type_abbreviation = IconTypeAbbreviations.fetch(icon_type)
    image_classes = ["icon", image_type_abbreviation, "fa-#{icon_name.to_s.parameterize}"]
    html_option_classes = html_options.fetch(:class, '').split(' ')
    css_classes = image_classes + html_option_classes
    caption = "&nbsp;#{caption}".html_safe if caption
    accessibility_options = accessible_label ? { aria: { label: accessible_label }} : { aria: { hidden: true }}
    html_options.merge!(class: css_classes.join(' ')).merge!(accessibility_options)
    content_tag(:i, caption, html_options)
  end
end
