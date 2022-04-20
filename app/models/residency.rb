class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  delegate :street_address, to: :property
  delegate :full_name, :email_address, to: :resident
  enum :resident_status, { deed_holder: 0, dependent: 1, renter: 2 }, scopes: true
end
