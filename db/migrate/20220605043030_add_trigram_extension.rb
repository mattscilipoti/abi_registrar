class AddTrigramExtension < ActiveRecord::Migration[7.0]
  def self.up
    enable_extension "pg_trgm"
  end
  def self.down
    disable_extension "pg_trgm"
  end
end
