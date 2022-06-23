class AddExtensionFuzzystrmatch < ActiveRecord::Migration[7.0]
  def self.up
    enable_extension "fuzzystrmatch"
  end
  def self.down
    disable_extension "fuzzystrmatch"
  end
end
