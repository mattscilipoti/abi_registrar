class LotDecorator < Draper::Decorator
  delegate_all

  def lot_number
    object.lot_number || "⁇"
  end

  def residents_summary(type: :icons)
    h.render 'residents/resident_icon_list', residents: object.residents.decorate
  end
end
