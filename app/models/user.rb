class User < ApplicationRecord
  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:email, :first_name, :last_name]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
  against: searchable_columns,
  using: {
    tsearch: { prefix: true }
  }

  validates_presence_of *searchable_columns

  def full_name
    [last_name, first_name].join(', ')
  end
end
