class ResidencyDecorator < Draper::Decorator
  delegate_all

  def lot_summary
    # Use leading zeros to create a "natural" sort
    sorted_lots = lots.sort_by{|lot| format('%010s' % lot.lot_number) }
    lots.collect{|lot| h.link_to(lot.lot_number, lot) }.join(', ').html_safe
  end

  def property_link_tag(tooltip: self.tooltip(show_resident: false))
    status_tag = h.link_to(object.property, class: 'no-link-icon' ) do
      resident_status_tag(tooltip: tooltip)
    end
    if object.verified_on?
      status_tag
      # h.concat(h.content_tag(:span, '✓', title: 'Verified at this address'))
    else
      h.content_tag(:div, class: 'group') do
        h.concat(status_tag)
        h.concat(helpers.simple_form_for(object, remote: true) do |f|
          f.input :verified_on, as: :hidden, input_html: { value: DateTime.now }
        end)
        tooltip = "Click to verify: #{object.resident.full_name.inspect} at #{object.property.street_address.inspect}"
        h.concat(helpers.check_box_tag("#{object.to_global_id}_verified", object.verified?, object.verified?, onclick: 'updateVerifiedOn(this)', data: {tooltip: tooltip} ))
      end
    end
  end

  def resident_link_tag
    h.link_to(object.resident, resident.to_s)
  end

  def resident_status_character
    return '' if is_minor? # child

    case resident_status
    when nil
      '⁇'
    when /owner/
      '' # gavel
    when :renter.to_s
      '' # suitcase
    when :dependent.to_s
      # '' # family, pro
      '' # user-graduate
    else
      raise NotImplementedError, "Unknown resident_status: #{resident_status.inspect}"
    end
  end

  def resident_status_i18n
    if resident_status
      i18n_key = "activerecord.attributes.#{model_name.i18n_key}.resident_status.#{resident_status}"
      status = I18n.t(i18n_key)
      status || "⁇"
    else
      'Resident status: unknown'
    end
  end

  # def resident_status_link_tag(tooltip: self.tooltip(show_property: false, show_resident: false))
  #   h.link_to(object.resident, class: 'fas no-link-icon') do
  #     resident_status_tag(tooltip: tooltip)
  #   end
  # end
  def resident_status_link_tag(tooltip: self.tooltip(show_property: false))
    # h.link_to(object.resident, resident.to_s)
    status_tag = h.link_to(object.resident, class: 'no-link-icon' ) do
      resident_status_tag(tooltip: tooltip)
    end
    if object.verified_on?
      status_tag
      # h.concat(h.content_tag(:span, '✓', title: 'Verified at this address'))
    else
      h.content_tag(:div, class: 'group') do
        h.concat(status_tag)
        h.concat(helpers.simple_form_for(object, remote: true) do |f|
          f.input :verified_on, as: :hidden, input_html: { value: DateTime.now }
        end)
        tooltip = "Click to verify: #{object.resident.full_name.inspect} at #{object.property.street_address.inspect}"
        h.concat(helpers.check_box_tag("#{object.to_global_id}_verified", object.verified?, object.verified?, onclick: 'updateVerifiedOn(this)', data: {tooltip: tooltip} ))
      end
    end
  end

  def resident_status_tag(tooltip: resident_status_i18n)
    css_classes = %w[fas icon]
    css_classes << 'primary_residence' if primary_residence?
    css_classes << 'second_home' unless primary_residence?
    h.content_tag(:span, resident_status_character, class: css_classes.join(' '), data: {tooltip: tooltip})
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

  def tooltip(show_property: true, show_resident: true)
    info = []
    info << property.to_s if show_property
    info << resident.to_s if show_resident
    info << '2nd Home' unless primary_residence?
    info << resident_status_i18n
    info << 'verified' if verified_on?
    info.compact.join(", ")
  end
end
