class PropertyDecorator < Draper::Decorator
  delegate_all

  def icon_name
    case residents.first.last_name.downcase
    when 'scilipoti'
      'house-flood-water'
    when 'franklin, trustee'
      'house-heart'
    else    
      lot_fees_paid? ? 'house-circle-check' : 'house-circle-xmark'
    end
  end

  def lot_numbers
    # Use leading zeros to create a "natural" sort
    sorted_lots = lots.sort_by{|lot| format('%010s' % lot.lot_number) }
    lots.collect{|lot| h.link_to(lot.lot_number, lot) }.join(', ').html_safe
  end

  def residents_summary(type: :icons)
    h.render 'residents/resident_icon_list', residents: object.residents.decorate
  end

  def street_number
    object.street_number || "⁇"
  end
end
