class Resident < ApplicationRecord
  encrypts :age_of_minor
  encrypts :email_address, deterministic: true
  encrypts :first_name, deterministic: true

  enum :resident_status, { deed_holder: 0, dependent: 1, renter: 2 }

  has_many :residencies
  accepts_nested_attributes_for :residencies, reject_if: :all_blank, allow_destroy: true
  has_many :properties, through: :residencies

  validates :age_of_minor, numericality: { integer: true, less_than: 14 }
end
