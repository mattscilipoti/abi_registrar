class VoidReason < ApplicationRecord
  # Optional: restrict reasons to a specific amenity pass subclass name
  # pass_type can be nil for global reasons

  has_many :amenity_passes, dependent: :nullify

  validates :label, presence: true
  validates :code, uniqueness: true, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(Arel.sql('COALESCE(position, 9999) ASC, label ASC')) }
  scope :for_pass_type, ->(klass_name) { where(pass_type: [nil, klass_name]) }

  def to_param
    [id, label.parameterize].join('-')
  end

  def to_s
    label
  end
end
