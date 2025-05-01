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

  desc 'Removes VOID text from manually voided passes.'
  task remove_void_text: [:environment] do |task, args|
    amenity_passes_should_be_voided = AmenityPass.voided_legacy
    stats = {
      voided_passes_ct_at_start: AmenityPass.voided.count,
      amenity_passes_should_be_voided_ct: amenity_passes_should_be_voided.size,
    }
    # puts amenity_passes_should_be_voided.size
    # ap amenity_passes_should_be_voided
    puts "Removing VOID text from (#{amenity_passes_should_be_voided.size}) amenity passes..."
    amenity_passes_should_be_voided.each do |pass|
      print '  removing VOID text from '
      ap pass
      # Use update_columns to handle past Passes (which may not have today's requirements)
      # Note: this does NOT change updated_at
      corrected_description = pass.description.gsub(/\(VOID\)|VOID/i, '').strip
      corrected_sticker_number = pass.sticker_number.gsub(/\(VOID\)|VOID/i, '').strip if pass.sticker_number.present?
      corrected_description = nil if corrected_description.blank?
      corrected_sticker_number = nil if corrected_sticker_number.blank?
      pass.update_columns(description: corrected_description, sticker_number: corrected_sticker_number)

      Rails.logger.info "Removed VOID text from AmenityPass #{pass.id}: #{pass}"
    end

    stats_at_end = {
      voided_passes_ct_at_end: AmenityPass.voided.count,
    }
    final_stats = stats.merge(stats_at_end)
    Rails.logger.info "AmenityPass VOID text removal stats: #{final_stats}"
    ap final_stats
  end
end
