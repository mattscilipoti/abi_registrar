class ResidentDecorator < Draper::Decorator
  delegate_all

  def icon_name
    'user'
  end

  def mailing_address_i18n
    if object.mailing_address?
      address = OpenStruct.new(object.mailing_address) # formatted as StreetAddress, https://github.com/street-address-rb/street-address
      address_components = {
        "house_number" => address.house_number,
        "road" => address.road.upcase,
        "city" => address.city.upcase,
        "postcode" => address.zip_code,
        # "county" => "Anne Arundel",
        "state_code" => address.state_code,
        "country_code" => "US"
      }

      if address.unit
        address_components['unit'] = "#{address.prefix&.upcase} #{address.unit}"
      end

      mailing_address = AddressComposer.compose(address_components)

      recipient = object.try(:full_name)
      mailing_address.prepend "#{recipient.upcase}\n" if recipient

      mailing_address
    else
      object.primary_residence.try(:mailing_address, resident: self)
    end
  end

  def phone_i18n
    h.number_to_phone(object.phone, area_code: true)
  end

  def property_summary(type: :icons)
    h.render 'residencies/property_icon_list', residencies: resident.residencies.by_property.decorate
  end
end
