# frozen_string_literal: true

module AmenityPassValidations
  extend ActiveSupport::Concern

  included do
    # Validate season_year is within a sensible range when present.
    #
    # Require presence of season_year on create or any update to an existing record
    # (this allows legacy records with nil season_year to remain unchanged until
    # they are edited).
    validates :season_year, presence: true, if: :require_season_year_on_save?
    validates :season_year, numericality: { only_integer: true, greater_than_or_equal_to: 2023, less_than: 2100 }, allow_nil: true

    # Ensure sticker_number uniqueness across passes
    validates :sticker_number, presence: true, uniqueness: true
  end

  private

  # Return true for new records or any record that is being changed/saved.
  # This enforces presence for created records and for any update operation.
  def require_season_year_on_save?
    new_record? || changed?
  end


end
