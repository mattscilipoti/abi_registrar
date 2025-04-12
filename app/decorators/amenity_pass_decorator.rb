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
    template = case type
    when :icons
      'residencies/property_icon_list'
    when :list
      'residencies/property_list'
    else
      raise ArgumentError, "Invalid type: #{type}"
    end
    h.render template, residencies: resident.residencies.by_property.decorate
  end

  def street_addresses
    (object.resident.residencies.collect &:street_address).join(', ')
  end

  def toggleable_voided?
    h.toggleable_date_as_boolean(model: self, attribute_name: :voided_at, boolean_attribute_name: 'voided?')
  end

  def type_as_icon
    self.class.icon(html_options: { title: object.class.name })
  end

  # Displays voded datetime or a link to void the Amenity
  def voided?
    # Using a button styled link to navigate to the void action for the amenity
    if object.voided_at?
      h.datetime_tag(object.voided_at)
    else
      h.link_to("Void", h.void_beach_pass_path(object), class: "btn btn-warning")
    end
  end
end
