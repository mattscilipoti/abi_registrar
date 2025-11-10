require 'factory_bot'

module FactoryHelpers
  # Build a sticker number with a two-digit year prefix (last two digits of year),
  # a short prefix character(s), a separator, and a zero-padded sequence number.
  # Example: sticker_with_year('B', 12) => "B25-0012" (if current year is 2025)
  #
  # This picks a recent year (current year and up to 3 years back) but weights
  # the selection so the current year is more likely than older years.
  #
  # Expose as a module function so callers can use FactoryHelpers.sticker_with_year(...)
  # Module-level API used by callers who prefer `FactoryHelpers.sticker_with_year(...)`.
  # Keep the implementation centralized here (module method) and make the
  # instance method delegate to it so including classes still get an instance
  # method (FactoryBot::SyntaxRunner includes this module).
  def self.sticker_with_year(prefix, n, n_width: 4)
    current_season = AppSetting.current_season_year
  # Ensure we pick years >= configured minimum and allow next-year stickers
  # via AppSetting.max_season_year.
  min_year = [current_season - 3, AppSetting.min_season_year].max
    max_year = AppSetting.max_season_year

    years = (min_year..max_year).to_a

    relative_weights = {
      -1 => 5,   # next year
       0 => 45,  # current year
       1 => 25,
       2 => 15,
       3 => 10
    }

    weighted_pool = years.flat_map do |y|
      offset = current_season - y
      weight = relative_weights.fetch(offset, 1)
      [y] * weight
    end

    chosen = weighted_pool.sample
    yy = (chosen % 100).to_s.rjust(2, '0')

    if prefix.nil? || prefix.to_s.strip.empty?
      "#{yy}#{n.to_s.rjust(n_width, '0')}"
    else
      "#{prefix}-#{yy}#{n.to_s.rjust(n_width, '0')}"
    end
  end

  # Also include an Instance delegator used when module is included into FactoryBot::SyntaxRunner
  # so sequences can call `sticker_with_year(...)` directly.
  def sticker_with_year(prefix, n, n_width: 4)
    FactoryHelpers.sticker_with_year(prefix, n, n_width: n_width)
  end

  # Ensure the given resident has at least one property with mandatory fees paid.
  # If the resident has no properties, create one with the :mandatory_fees_paid trait
  # and attach a residency as owner. If a property exists but is missing the
  # mandatory fee timestamps, set them to now.
  def ensure_property_with_mandatory_fees(resident)
    return if resident.nil?

    if resident.properties.empty?
      prop = FactoryBot.create(:property, :mandatory_fees_paid)
      FactoryBot.create(:residency, property: prop, resident: resident, resident_status: :owner)
    else
      prop = resident.properties.first
      prop.update(lot_fees_paid_on: Time.zone.now) if prop.lot_fees_paid_on.nil?
      prop.update(user_fee_paid_on: Time.zone.now) if prop.user_fee_paid_on.nil?
    end
    prop
  end

  def self.ensure_property_with_mandatory_fees(resident)
    new = Object.new
    FactoryHelpers.instance_method(:ensure_property_with_mandatory_fees).bind(new).call(resident)
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
