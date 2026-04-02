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
    require 'csv'

    dry_run = ENV['DRY_RUN'].present?
    batch_size = (ENV['BATCH'] || 1000).to_i
    verbose = ENV['VERBOSE'].present?

    max_year = AppSetting.max_season_year
    min_year = AppSetting.min_season_year

    puts "Starting amenity_passes:backfill_season_year" + (dry_run ? " (DRY RUN)" : "")
    puts "Batch size: #{batch_size}, accepting years between #{min_year} and #{max_year}" if verbose

    scope = AmenityPass.where(season_year: nil).where.not(sticker_number: [nil, ''])
    total_candidates = scope.count
    puts "Found #{total_candidates} candidate amenity_passes with nil season_year and sticker_number present"

    processed = 0
    updated = 0
    issues = []

    timestamp = Time.zone.now.utc.strftime('%Y%m%d%H%M%S')
    issues_path = ENV['ISSUES_FILE'] || File.join(Rails.root, 'tmp', "backfill_season_year_issues_#{timestamp}.csv")

    scope.find_in_batches(batch_size: batch_size) do |batch|
      batch.each do |pass|
        processed += 1
        sn = pass.sticker_number.to_s

        # Delegate parsing to the model helper which returns 20YY or nil.
        year_int = AmenityPass.guess_season_year_from_sticker(sn)

        unless year_int
          msg = "no_two_digit_year"
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> #{msg}" if verbose
          issues << { id: pass.id, sticker_number: sn, reason: msg, details: sn }
          next
        end

        unless year_int.between?(min_year, max_year)
          msg = "out_of_range"
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> candidate year=#{year_int} out of range (#{min_year}-#{max_year})" if verbose
          issues << { id: pass.id, sticker_number: sn, reason: msg, details: year_int }
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
            msg = "update_error"
            warn "Failed to update AmenityPass id=#{pass.id}: #{e.class} #{e.message}"
            issues << { id: pass.id, sticker_number: sn, reason: msg, details: "#{e.class}: #{e.message}" }
          end
        end
      end
    end

    if issues.any?
      CSV.open(issues_path, 'w', write_headers: true, headers: %w[id sticker_number reason details]) do |csv|
        issues.each do |h|
          csv << [h[:id], h[:sticker_number], h[:reason], h[:details]]
        end
      end
      puts "Wrote #{issues.size} issue(s) to #{issues_path}"
    else
      puts "No issues to write."
    end

    puts "Done. Processed #{processed} candidates; #{dry_run ? 'would update' : 'updated'} #{updated} records."
  end
end
