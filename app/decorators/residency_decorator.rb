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
               # house-heart, pro
            else    
              lot_fees_paid? ? '' : '' # house-circle-check, house-circle-xmark
            end

    h.content_tag(:span, icon, class: 'fas', data: {tooltip: property.to_s})
  end

  def resident_status_character
    return '' if is_minor? # child

    case resident_status
    when nil
      '?'
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

  def resident_status_tag
    h.content_tag(:span, resident_status_character, class: 'fas', data: {tooltip: resident_status_i18n})
  end

  def resident_status_i18n
    status = I18n.t("activerecord.attributes.#{model_name.i18n_key}.resident_status.#{resident_status}")
    status || "⁇"
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
    summary += ")"
    summary
  end
end
