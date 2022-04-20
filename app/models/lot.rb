class Lot < ApplicationRecord
  belongs_to :property, optional: true

  validates :district, numericality: { only_integer: true }
  validates :subdivision, numericality: { only_integer: true }
  validates :account_number, numericality: { only_integer: true }
  validates :section, numericality: { only_integer: true, in: 1..5 }
  validates :size, inclusion: { in: [0.5, 1] }

  def tax_identifier
    formatted_district = format('%02d', district)
    [formatted_district, subdivision, account_number].join(' ')
  end
end
