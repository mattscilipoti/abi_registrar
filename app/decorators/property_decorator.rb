class PropertyDecorator < Draper::Decorator
  delegate_all

  def icon_name
    lot_fees_paid? ? 'house-circle-check' : 'house-circle-xmark'
  end
end
