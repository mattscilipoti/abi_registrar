class AmenityPassDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def self.icon(accessible_label: nil, caption: nil, icon_type: :solid, html_options: {})
    helpers.font_awesome_icon(icon_name, accessible_label: accessible_label, caption: caption, icon_type: icon_type, html_options: html_options)
  end

  def self.icon_name
    raise NotImplementedError, 'Must define in child'
  end

  def property_summary(type: :icons)
    h.render 'residencies/property_icon_list', residencies: object.resident.residencies.decorate
  end

  def street_addresses
    (object.resident.residencies.collect &:street_address).join(', ')
  end

  def type_as_icon
    self.class.icon(html_options: { title: object.class.name })
  end

  def voided?
    h.datetime_as_boolean_tag(voided_at)
  end
end
