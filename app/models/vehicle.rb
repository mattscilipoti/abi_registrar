require 'csv' # for states

class Vehicle < ApplicationRecord
  belongs_to :resident
  has_many :properties, :through => :resident

  validate :resident_paid_lot_fees

  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:state_code, :sticker_number, :tag_number]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: searchable_columns,
    associated_against: {
      resident: Resident.searchable_columns,
      properties: Property.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  scope :not_paid, -> { where('1=2') } # TODO: sticker fee not paid?
  scope :problematic, -> { without_sticker_number.or(without_tag_number).or(without_state_code) }
  scope :without_tag_number, -> { where(tag_number: nil) }
  scope :without_state_code, -> { where(state_code: nil) }
  scope :without_sticker_number, -> { where(sticker_number: nil) }

  validates_presence_of :tag_number, :sticker_number
  
  # Useful for form collections
  # Displays summary, returns code
  # With
  def self.states
    @states ||= begin
      data_file = Rails.root.join('db', 'import', 'US_States.csv')
      state_data = table = CSV.table(data_file,
        encoding: "bom|utf-8",
        header_converters: [:downcase, :symbol],
        headers: :first_row,
        skip_blanks: true,
        strip: true,
      )
      default_state = { "MD-Maryland" => "MD" }
      state_data.inject(default_state) do |states, row| 
        name = row.fetch(:state)
        code = row.fetch(:code)
        summary = [code, name].join('-')
        states[summary] = code 
        states
      end
    end
  end

  def resident_paid_lot_fees
    unless resident.lot_fees_paid?
      errors.add(:resident, "must pay lot fees")
    end
  end

  def tag
    [state_code, tag_number].compact.join('-')
  end

  def to_s
    [sticker_number, tag].compact.join(', ')
  end
end
