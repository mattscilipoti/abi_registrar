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

  def toggleable_lot_fee_paid?
    h.form_with model: lot, data: { controller: 'autosave'} do |f|
      h.concat(f.hidden_field :paid_on, value: Date.today)
      h.concat(f.check_box :lot_fee_paid?, data: { action: 'autosave#save' })
    end
  end

end
