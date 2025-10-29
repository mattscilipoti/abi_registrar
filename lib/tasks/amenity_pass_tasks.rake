namespace :amenity_passes do

  desc 'Converts Vehicle Passes (U*,GOLF) to UtilityPasses'
  task convert_vehicle_passes_to_utility_cart_passes: [:environment] do |task, args|
    vehicle_passes_should_be_utility = VehicleParkingPass.utility_cart_passes
    stats = {
      vehicle_passes_ct_at_start: VehicleParkingPass.count,
      utility_cart_passes_ct_at_start: UtilityCartPass.count,
      vehicle_passes_should_be_utility_ct: vehicle_passes_should_be_utility.size,
    }
    # puts vehicle_passes_should_be_utility.size
    # puts vehicle_passes_should_be_utility
    puts "Converting (#{vehicle_passes_should_be_utility.size}) vehicle passes..."
    vehicle_passes_should_be_utility.each do |pass|
      utility_pass = pass.becomes(UtilityCartPass)
      converted_attributes = {
        type: UtilityCartPass.name,
        description: pass.tag_number,
        tag_number: nil,
        state_code: nil,
      }
      #debugger
      utility_pass.attributes = converted_attributes
      print '  converting '
      ap utility_pass
      # Use update_columns to handle past Passes (which may not have today's requirements)
      # Note: this does NOT change updated_at
      utility_pass.update_columns(converted_attributes)
      Rails.logger.info "Converted UtilityCartPass #{utility_pass.id}: #{utility_pass}"
    end

    stats_at_end = {
      vehicle_passes_ct_at_end: VehicleParkingPass.count,
      utility_cart_passes_ct_at_end: UtilityCartPass.count,
    }
    final_stats = stats.merge(stats_at_end)
    Rails.logger.info "UtilityCartPass conversion stats: #{final_stats}"
    ap final_stats
  end

  desc 'Converts manually voided passes to voided.'
  task void_passes: [:environment] do |task, args|
    amenity_passes_should_be_voided = AmenityPass.voided_legacy
    stats = {
      unvoided_passes_ct_at_start: AmenityPass.not_voided.count,
      voided_passes_ct_at_start: AmenityPass.voided.count,
      amenity_passes_should_be_voided_ct: amenity_passes_should_be_voided.size,
    }
    # puts amenity_passes_should_be_voided.size
    # ap amenity_passes_should_be_voided
    puts "Voiding (#{amenity_passes_should_be_voided.size}) amenity passes..."
    amenity_passes_should_be_voided.each do |pass|

      #debugger_
      print '  voiding '
      ap pass
      # Use update_columns to handle past Passes (which may not have today's requirements)
      # Note: this does NOT change updated_at
      pass.void
      # pass.void_reason_id = ??? # other
      pass.void_reason = 'Batch update'
      Rails.logger.info "Voided AmenityPass #{pass.id}: #{pass}"
    end

    stats_at_end = {
      unvoided_passes_ct_at_end: AmenityPass.not_voided.count,
      voided_passes_ct_at_end: AmenityPass.voided.count,
    }
    final_stats = stats.merge(stats_at_end)
    Rails.logger.info "AmenityPass voided stats: #{final_stats}"
    ap final_stats
  end

  desc 'Seeds random AmenityPasses with various legacy VOID-like sticker formats for testing.'
  task seed_legacy_void: [:environment] do |_task, _args|
    require 'securerandom'

    total = (ENV['COUNT'] || 25).to_i
    raise ArgumentError, 'COUNT must be >= 1' if total < 1

    # Choose a resident to attach passes to. Prefer one with mandatory fees paid.
    resident = Resident.mandatory_fees_paid.first || Resident.first
    resident_pool = Resident.mandatory_fees_paid.to_a

    if resident.nil?
      # Minimal resident fallback to ensure NOT NULL resident_id; keep it simple and skip validations later
      resident = Resident.create!(last_name: "VoidSeed", first_name: "Test")
    end

    # Build a valid-ish base sticker (letter-hyphen-digits), then mangle it with VOID patterns
    base_sticker = -> do
      letter = ("A".."Z").to_a.sample
      number = rand(10_000..999_999)
      "#{letter}-#{number}"
    end

    patterns = [
      ->(s) { "VOID #{s}" },            # starts with "VOID "
      ->(s) { s.sub('-', '(VOID)-') },   # contains "(VOID)" in the middle
      ->(s) { "#{s} (VOID)" },          # ends with "(VOID)"
      ->(s) { "#{s} VOID" },            # ends with "VOID"
      ->(s) { "#{s}-VOID" },             # ends with "-VOID"
      ->(s) { "#{s}- VOID" },             # ends with "- VOID"
      ->(s) { "#{s} -VOID" }             # ends with " -VOID"
    ]

    # Ensure subclasses are loaded and available for random selection
    subclasses = [
      BeachPass,
      BoatRampAccessPass,
      DinghyDockStoragePass,
      UtilityCartPass,
      VehicleParkingPass,
      WatercraftStoragePass,
    ]

    created = []
    attempts = 0
    puts "Seeding #{total} VOID-like AmenityPass records for resident ##{resident.id} (#{resident.full_name})"

    while created.size < total && attempts < total * 5
      attempts += 1
      raw = base_sticker.call
      sticker = patterns[created.size % patterns.length].call(raw)
      klass = subclasses.sample
      chosen_resident = (resident_pool.sample || resident)
      attrs = {
        resident_id: chosen_resident.id,
        sticker_number: sticker,
        description: "TEST DATA: seeded with legacy VOID-like sticker '#{sticker}'",
      }

      pass = klass.new(attrs)
      # Skip validations so we can insert invalid sticker formats intentionally
      begin
        if pass.save(validate: false)
          created << pass
          puts "  created #{klass.name} ##{pass.id} with sticker_number='#{sticker}' (resident ##{chosen_resident.id})"
        end
      rescue ActiveRecord::RecordNotUnique
        # Rare collision on unique sticker_number; try again with a different base
        next
      end
    end

    puts "Done. Created #{created.size}/#{total} AmenityPass records."
    Rails.logger.info({ task: 'amenity_passes:seed_legacy_void', created: created.size, requested: total })
  end

  desc 'Removes VOID text from manually voided passes.'
  task remove_void_text: [:environment] do |task, args|
    amenity_passes_should_be_voided = AmenityPass.voided_legacy
    stats = {
      voided_passes_ct_at_start: AmenityPass.voided.count,
      amenity_passes_should_be_voided_ct: amenity_passes_should_be_voided.size,
    }

    # Helper to remove VOID markers, then trailing spaces, then a trailing hyphen (optionally surrounded by spaces)
    cleanup_text = ->(text) do
      return nil if text.blank?
      s = text.gsub(/\(VOID\)|VOID/i, '')
      s = s.gsub(/\s+\z/, '')          # remove trailing whitespace
      s = s.gsub(/\s*-\s*\z/, '')     # remove trailing hyphen with optional surrounding spaces
      s = s.strip
      s.presence
    end

    # Helper to only trim trailing spaces and dangling hyphens (no VOID removal)
    trim_trailing = ->(text) do
      return nil if text.blank?
      s = text.gsub(/\s+\z/, '')      # trailing whitespace
      s = s.gsub(/\s*-\s*\z/, '')     # trailing hyphen with optional surrounding spaces
      s = s.strip
      s.presence
    end

    # Pass 1: Remove VOID markers on the legacy set
    puts "Pass 1: Removing VOID text from (#{amenity_passes_should_be_voided.size}) amenity passes..."
    updated_p1 = 0
    amenity_passes_should_be_voided.find_each do |pass|
      corrected_description = cleanup_text.call(pass.description)
      corrected_sticker_number = cleanup_text.call(pass.sticker_number) if pass.sticker_number.present?
      if corrected_description != pass.description || corrected_sticker_number != pass.sticker_number
        pass.update_columns(description: corrected_description, sticker_number: corrected_sticker_number)
        updated_p1 += 1
      end
    end
    puts "  Pass 1 updated: #{updated_p1}"

    # Pass 2: Normalize trailing spaces/dangling hyphens on any remaining records
    trailing_regex = '\\s+$|\\s*-\\s*$'
    records_needing_trim = AmenityPass.where("sticker_number ~ ? OR description ~ ?", trailing_regex, trailing_regex)
    puts "Pass 2: Trimming trailing spaces/hyphens from (#{records_needing_trim.count}) amenity passes..."
    updated_p2 = 0
    records_needing_trim.find_each do |pass|
      corrected_description = trim_trailing.call(pass.description)
      corrected_sticker_number = trim_trailing.call(pass.sticker_number) if pass.sticker_number.present?
      if corrected_description != pass.description || corrected_sticker_number != pass.sticker_number
        pass.update_columns(description: corrected_description, sticker_number: corrected_sticker_number)
        updated_p2 += 1
      end
    end
    puts "  Pass 2 updated: #{updated_p2}"

    stats_at_end = {
      voided_passes_ct_at_end: AmenityPass.voided.count,
      pass1_updated: updated_p1,
      pass2_updated: updated_p2,
    }
    final_stats = stats.merge(stats_at_end)
    Rails.logger.info "AmenityPass VOID text removal stats: #{final_stats}"
    ap final_stats
  end

  desc 'Normalizes trailing spaces and trailing hyphens in sticker_number and description across all AmenityPasses.'
  task normalize_trailing: [:environment] do |_task, _args|
    # Only target records that appear to have trailing whitespace or a dangling hyphen
    pattern = '\\s+$|\\s*-\\s*$'
    scope = AmenityPass.where("sticker_number ~ ? OR description ~ ?", pattern, pattern)

    stats = {
      candidates: scope.count,
      updated: 0,
    }

    tidy = ->(text) do
      return nil if text.blank?
      s = text.gsub(/\s+\z/, '')         # remove trailing whitespace
      s = s.gsub(/\s*-\s*\z/, '')      # remove trailing hyphen with optional surrounding spaces
      s = s.strip
      s.presence
    end

    puts "Normalizing trailing spaces/hyphens for #{stats[:candidates]} AmenityPass records..."
    scope.find_each(batch_size: 500) do |pass|
      new_desc = tidy.call(pass.description)
      new_sticker = tidy.call(pass.sticker_number)

      next if new_desc == pass.description && new_sticker == pass.sticker_number

      pass.update_columns(description: new_desc, sticker_number: new_sticker)
      stats[:updated] += 1
    end

    Rails.logger.info({ task: 'amenity_passes:normalize_trailing', stats: stats })
    ap stats
  end

  desc 'Cleans legacy VOID markers then normalizes trailing spaces/hyphens.'
  task cleanup_void_and_trailing: [:environment] do
    Rake::Task['amenity_passes:remove_void_text'].invoke
    # Reenable not necessary unless called multiple times in same process
    Rake::Task['amenity_passes:normalize_trailing'].invoke
  end
end
