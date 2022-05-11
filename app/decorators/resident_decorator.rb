class ResidentDecorator < Draper::Decorator
  delegate_all

  def property_summary(type: :icons)
    h.render 'properties/property_icon_list', properties: object.properties.decorate
  end
end
