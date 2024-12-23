class PropertyDecorator < Draper::Decorator
  delegate_all

  def icon_name
    case residents.first.last_name.downcase
    when 'scilipoti'
      'house-flood-water'
    when 'franklin, trustee'
      'house-heart' # pro
    else
      mandatory_fees_paid? ? 'house-circle-check' : 'house-circle-xmark'
    end
  end

  def lot_numbers
    # Use leading zeros to create a "natural" sort
    sorted_lots = lots.decorate.sort_by{|lot| format('%010s' % lot.lot_number) }
    sorted_lots.collect{|lot| h.link_to(lot.lot_number, lot) }.join(', ').html_safe
  end

  def residents_summary(type: :icons)
    h.render 'residencies/resident_icon_list', residencies: object.residencies.decorate
  end

  def street_number
    object.street_number || "⁇"
  end

  def toggleable_amenities_processed?
    toggleable_date_as_boolean(model: property, attribute_name: :amenities_processed)
  end

  def toggleable_for_sale?
    h.form_with model: property, data: { controller: 'autosave'} do |f|
      f.check_box :for_sale, data: { action: 'autosave#save' }
    end

    # h.simple_form_for(property, remote: true) do |f|
    #   f.input :for_sale, label: false, input_html: {data: { url: h.property_path(property), remote: true, method: :patch }}
    # end

    # data-remote
    # h.check_box_tag 'for_sale', '1', property.for_sale,
    #   onchange: "this.setAttribute('data-params', 'checked=' + this.checked*this.checked)",
    #   data: { remote: true, url: h.property_path(property), method: :patch }
  end

  def toggleable_lot_fees_paid?
    toggleable_date_as_boolean(model: property, attribute_name: :lot_fees_paid_on, boolean_attribute_name: 'lot_fees_paid?')
  end

  def toggleable_user_fee_paid?
    toggleable_date_as_boolean(model: property, attribute_name: :user_fee_paid_on)
  end

  private

  def toggleable_date_as_boolean(model:, attribute_name:, boolean_attribute_name: "#{attribute_name}?")
    h.form_with model: model, data: { controller: 'autosave'} do |f|
      data_attrs = { action: 'autosave#save' }
      attribute_value = model.send(attribute_name)
      data_attrs[:tooltip] = "On: #{attribute_value} (#{h.time_ago_in_words(attribute_value)} ago)" if attribute_value
      f.check_box boolean_attribute_name, data: data_attrs
    end
  end


end
