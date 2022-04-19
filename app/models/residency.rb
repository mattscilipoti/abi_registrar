class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  delegate :street_address, to: :property
  enum :resident_status, { deed_holder: 0, dependent: 1, renter: 2 }, scopes: true
end
