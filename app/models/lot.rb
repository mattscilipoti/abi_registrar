class Lot < ApplicationRecord
  validates :district, numericality: { only_integer: true }
  validates :subdivision, numericality: { only_integer: true }
  validates :account_number, numericality: { only_integer: true }
  validates :section, numericality: { only_integer: true, in: 1..5 }
  validates :size, inclusion: { in: [0.5, 1] }
end
