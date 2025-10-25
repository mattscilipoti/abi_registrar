require 'factory_bot'

module FactoryHelpers
  # Build a sticker number with a two-digit year prefix (last two digits of year),
  # a short prefix character(s), a separator, and a zero-padded sequence number.
  # Example: sticker_with_year('B', 12) => "B25-0012" (if current year is 2025)
  def sticker_with_year(prefix, n, n_width: 4)
    # pick a random recent year within the past 5 years (inclusive)
    current_year = Time.zone.now.year
    min_year = current_year - 3
    chosen = rand(min_year..current_year)
    yy = (chosen % 100).to_s.rjust(2, '0')
    "#{prefix}-#{yy}#{n.to_s.rjust(n_width, '0')}"
  end

  # Also expose as a module function so callers can use FactoryHelpers.sticker_with_year(...)
  def self.sticker_with_year(prefix, n, n_width: 4)
    new = Object.new
    # call the instance method implementation
    FactoryHelpers.instance_method(:sticker_with_year).bind(new).call(prefix, n, n_width: n_width)
  end
end

# Make helper available inside FactoryBot sequences. Guard in case FactoryBot
# is not yet loaded at the time this file is required during spec boot.
begin
  FactoryBot::SyntaxRunner.include FactoryHelpers
rescue NameError
  RSpec.configure do |config|
    config.before(:suite) do
      FactoryBot::SyntaxRunner.include FactoryHelpers
    end
  end
end
