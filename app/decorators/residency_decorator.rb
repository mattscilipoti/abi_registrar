class ResidencyDecorator < Draper::Decorator
  delegate_all

  def lot_summary
    # Use leading zeros to create a "natural" sort
    sorted_lots = lots.sort_by{|lot| format('%010s' % lot.lot_number) }
    lots.collect{|lot| h.link_to(lot.lot_number, lot) }.join(', ').html_safe
  end

  def property_summary
    "#{resident_status_tag} #{object.property.to_s}".html_safe
  end

  def property_tag
    icon =  case object.resident.last_name.downcase
            when 'scilipoti'
              '' # house-flood-water
            when 'franklin, trustee'
              '' # house-heart, pro
              '' # house-laptop
            else
              lot_fees_paid? ? '' : '' # house-circle-check, house-circle-xmark
            end
    css_classes = %w[fas icon]
    css_classes << 'primary_residence' if primary_residence?
    css_classes << 'second_home' unless primary_residence?

    tooltip = property.to_s
    tooltip += ':2nd Home' unless primary_residence

    h.content_tag(:span, icon, class: css_classes.join(' '), data: {tooltip: tooltip})
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

  def resident_status_tag(tooltip: resident_status_i18n)
    css_classes = %w[fas icon]
    css_classes << 'primary_residence' if primary_residence?
    css_classes << 'second_home' unless primary_residence?
    h.content_tag(:span, resident_status_character, class: css_classes.join(' '), data: {tooltip: tooltip})
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

  def resident_summary
    summary = full_name
    summary += "("
    summary += resident_status_i18n
    summary += ", minor" if is_minor?
    summary += ", 2nd home" unless primary_residence?
    summary += ")"
    summary
  end
end
