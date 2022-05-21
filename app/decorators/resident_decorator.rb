class ResidentDecorator < Draper::Decorator
  delegate_all

  def icon_name
    'user'
  end

  def phone
    h.number_to_phone(object.phone, area_code: true)
  end

  def property_summary(type: :icons)
    h.render 'residencies/property_icon_list', residencies: resident.residencies.decorate
  end
end
