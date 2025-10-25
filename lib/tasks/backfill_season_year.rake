# Backfill season_year for AmenityPass records by parsing the sticker number
# and extracting a recent 2-digit year prefix from the first numeric run.
# Example: "AB24-123" -> '24' -> 2024 (if within accepted recent range).
#
# Usage:
#   # dry run (no DB writes)
#   rake amenity_passes:backfill_season_year DRY_RUN=true VERBOSE=true
#
#   # perform updates in batches of 500
#   rake amenity_passes:backfill_season_year BATCH=500
#
namespace :amenity_passes do
  desc "Backfill season_year from sticker_number 2-digit year prefix (recent years only)"
  task backfill_season_year: :environment do
    dry_run = ENV['DRY_RUN'].present?
    batch_size = (ENV['BATCH'] || 1000).to_i
    verbose = ENV['VERBOSE'].present?

  current_year = Time.zone.now.year
  min_year = current_year - 4

    puts "Starting amenity_passes:backfill_season_year" + (dry_run ? " (DRY RUN)" : "")
    puts "Batch size: #{batch_size}, accepting years between #{min_year} and #{current_year}" if verbose

  scope = AmenityPass.where(season_year: nil).where.not(sticker_number: [nil, ''])
    total_candidates = scope.count
    puts "Found #{total_candidates} candidate amenity_passes with nil season_year and sticker_number present"

    processed = 0
    updated = 0

    scope.find_in_batches(batch_size: batch_size) do |batch|
      batch.each do |pass|
        processed += 1
        sn = pass.sticker_number.to_s
        # Use the AmenityPass#sticker_digits helper (first numeric run) and
        # interpret its first two digits as the last two digits of a year.
        digits = pass.sticker_digits
        unless digits && digits.length >= 2
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> no numeric run found" if verbose
          next
        end

        first_two = digits[0,2]
        unless first_two =~ /\A\d{2}\z/
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> first two chars '#{first_two}' not digits" if verbose
          next
        end

        yy = first_two.to_i
        year_int = 2000 + yy
        unless year_int.between?(min_year, current_year)
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> candidate year=#{year_int} out of range (#{min_year}-#{current_year})" if verbose
          next
        end

        if dry_run
          puts "[DRY] Would set AmenityPass id=#{pass.id} season_year=#{year_int} (sticker=#{sn})" if verbose
          updated += 1
        else
          begin
            pass.update_columns(season_year: year_int)
            updated += 1
            puts "Updated AmenityPass id=#{pass.id} -> season_year=#{year_int}" if verbose
          rescue => e
            warn "Failed to update AmenityPass id=#{pass.id}: #{e.class} #{e.message}"
          end
        end
      end
    end

    puts "Done. Processed #{processed} candidates; #{dry_run ? 'would update' : 'updated'} #{updated} records."
  end
end
