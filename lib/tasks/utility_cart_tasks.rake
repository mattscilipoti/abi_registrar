namespace :utility_carts do
  desc 'Converts Vehhicle Passes (U*,GOLF) to UtilityPasses'
  task convert_vehicle_passes: [:environment] do |task, args|
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
end
