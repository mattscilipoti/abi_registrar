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
      utility_pass.type = UtilityCartPass.name
      utility_pass.description = pass.tag_number
      utility_pass.tag_number = nil
      print '  converting '
      ap utility_pass
      #debugger
      utility_pass.save!
      Rails.logger.info "Converted #{utility_pass.id}: #{utility_pass}"
    end

    stats_at_end = {
      vehicle_passes_ct_at_end: VehicleParkingPass.count,
      utility_cart_passes_ct_at_end: UtilityCartPass.count,
    }
    ap stats.merge(stats_at_end)
  end
end
