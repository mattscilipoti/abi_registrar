class Resident < ApplicationRecord
  encrypts :age_of_minor
  encrypts :email_address, deterministic: true
  encrypts :first_name, deterministic: true

  has_many :residencies
  accepts_nested_attributes_for :residencies, reject_if: :all_blank, allow_destroy: true
  has_many :properties, through: :residencies

  validates :age_of_minor, numericality: { integer: true, greater_than: 0, less_than: 14, allow_blank: true }
  validates :last_name, presence: true

  def full_name
    [last_name, first_name].join(', ')
  end
    
  def property_count
    properties.size
  end
end
