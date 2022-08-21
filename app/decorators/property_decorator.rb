class PropertyDecorator < Draper::Decorator
  delegate_all

  def icon_name
    case residents.first.last_name.downcase
    when 'scilipoti'
      'house-flood-water'
    when 'franklin, trustee'
      'house-heart' # pro
    else
      lot_fees_paid? ? 'house-circle-check' : 'house-circle-xmark'
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
end
