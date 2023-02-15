class ResidencyDecorator < Draper::Decorator
  delegate_all

  def lot_summary
    # Use leading zeros to create a "natural" sort
    sorted_lots = lots.sort_by{|lot| format('%010s' % lot.lot_number) }
    lots.collect{|lot| h.link_to(lot.lot_number, lot) }.join(', ').html_safe
  end

  def phone_formatted
    h.number_to_phone(phone)
  end

  def property_link_tag(tooltip: self.tooltip(show_resident: false))
    status_tag = h.link_to(object.property, class: 'no-link-icon' ) do
      resident_status_tag(tooltip: tooltip)
    end
    if object.verified?
      status_tag
      # h.concat(h.content_tag(:span, '✓', title: 'Verified at this address'))
    else
      h.content_tag(:div, class: 'group') do
        h.concat(status_tag)
        h.concat(helpers.simple_form_for(object, remote: true) do |f|
          f.input :verified_on, as: :hidden, input_html: { value: Time.zone.now }
        end)
        tooltip = "Click to verify: #{object.resident.full_name.inspect} at #{object.property.street_address.inspect}"
        h.concat(helpers.check_box_tag("#{object.to_global_id}_verified", object.verified?, object.verified?, onclick: 'updateVerifiedOn(this)', data: {tooltip: tooltip} ))
      end
    end
  end

  def resident_link_tag
    h.link_to(object.resident, resident.to_s)
  end

  def resident_status_character(resident_status = object.resident_status)
    h.resident_status_character(resident_status, is_minor?)
  end

  def resident_status_i18n
    if resident_status
      # Convert from key to name
      Residency.resident_statuses[resident_status]
    else
      'Resident status: unknown'
    end
  end

  def resident_status_link_tag(show_property: false, show_resident: false)
    tooltip = self.tooltip(show_property: show_property, show_resident: show_resident)
    h.link_to(object.resident, class: 'fas no-link-icon') do
      resident_status_tag(tooltip: tooltip)
    end
  end

  def resident_updatable_status_link_tag(tooltip: self.tooltip(show_property: false))
    if object.resident_status
      return h.link_to(object.resident, class: 'no-link-icon' ) do
        resident_status_tag(resident_status: object.resident_status, tooltip: tooltip)
      end
    end

    # present all, with ability to assign one
    list_item_tags = Residency.resident_statuses.collect do |status_key, status_name|
      h.content_tag(:li, class: 'group') do
        h.concat(h.content_tag(:span, class: 'fas icon', data: {tooltip: status_name}) do
          h.resident_status_character(status_key, false)
        end)
        h.concat(status_name)
        h.concat(helpers.simple_form_for(object, remote: true) do |f|
          h.concat(f.input :resident_status, as: :hidden, input_html: { value: status_name })
          h.concat(f.input :verified_on, as: :hidden, input_html: { value: Time.zone.now })
        end)
        tooltip = "Click to assign: #{object.resident.full_name.inspect} as #{status_name} at #{object.property.street_address.inspect}"
        # h.concat(helpers.check_box_tag("#{object.to_global_id}_verified", object.verified?, object.verified?, onclick: 'updateVerifiedOn(this)', data: {tooltip: tooltip} ))
        h.concat(helpers.check_box_tag("#{object.to_global_id}_resident_status", status_name, false, onclick: 'updateResidentStatus(this)', data: {tooltip: tooltip} ))
      end
    end
    h.content_tag(:ul, class: 'horizontal-list') do
      h.safe_join(list_item_tags)
    end
  end

  def resident_status_tag(resident_status: object.resident_status, tooltip: resident_status_i18n)
    css_classes = %w[fas icon]
    css_classes << 'primary_residence' if primary_residence?
    css_classes << 'second_home' unless primary_residence?
    h.content_tag(:span, resident_status_character(resident_status), class: css_classes.join(' '), data: {tooltip: tooltip})
  end

  def resident_status_icon
    icon_name = case resident_status
    when nil
      :question
    when /owner/
      :gavel
    when :renter.to_s
      :suitcase
    when :depenent.to_s
      'user-graduate'
    else
      raise NotImplementedError, "Unknown resident_status: #{resident_status.inspect}"
    end
    h.font_awesome_icon(icon_name, accessible_label: resident_status_i18n, html_options: {data: {tooltip: resident_status_i18n}})
  end

  def tooltip(show_property: true, show_resident: true, show_resident_phone: true)
    info = []
    info << property.to_s if show_property
    info << resident.to_s if show_resident
    info << '2nd Home' unless primary_residence?
    # info << resident_status_i18n
    if show_resident_phone && resident.phone
      info << phone_formatted
    end
    info << 'verified' if verified?
    info.compact.join(", ")
  end
end
