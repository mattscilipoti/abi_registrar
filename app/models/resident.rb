class Resident < ApplicationRecord
  encrypts :age_of_minor
  encrypts :email_address, deterministic: true
  encrypts :first_name, deterministic: true

  has_many :residencies
  has_many :properties, through: :residencies

  validates :age_of_minor, numericality: { integer: true, less_than: 14 }
end
