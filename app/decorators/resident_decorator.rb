class ResidentDecorator < Draper::Decorator
  delegate_all

  def property_icons
    h.render 'properties/property_icon_list', properties: object.properties
  end
end
