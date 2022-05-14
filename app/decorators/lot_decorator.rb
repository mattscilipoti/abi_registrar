class LotDecorator < Draper::Decorator
  delegate_all

  def residents_summary(type: :icons)
    h.render 'residents/resident_icon_list', residents: object.residents.decorate
  end
end
