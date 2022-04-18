class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
end
