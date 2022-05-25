class LotDecorator < Draper::Decorator
  delegate_all

  def lot_number
    object.lot_number || "⁇"
  end

  def paid_on
    h.date_tag(object.paid_on)
  end

  def residents_summary(type: :icons)
    h.render 'residents/resident_icon_list', residents: object.residents.decorate
  end
end
