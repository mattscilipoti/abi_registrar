class PropertyDecorator < Draper::Decorator
  delegate_all

  def icon_name
    lot_fees_paid? ? 'house-circle-check' : 'house-circle-xmark'
  end

  def lot_numbers
    # Use leading zeros to create a "natural" sort
    lots.pluck(:lot_number).sort_by{|l| format('%010s' % l)}.join(', ')
  end
end
