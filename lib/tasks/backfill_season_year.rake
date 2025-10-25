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

    current_year = Time.zone.now.year
    min_year = current_year - 4

    puts "Starting amenity_passes:backfill_season_year" + (dry_run ? " (DRY RUN)" : "")
    puts "Batch size: #{batch_size}, accepting years between #{min_year} and #{current_year}" if verbose

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
        digits = pass.sticker_digits

        unless digits && digits.length >= 2
          msg = "no_numeric_run"
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> #{msg}" if verbose
          issues << { id: pass.id, sticker_number: sn, reason: msg, details: digits.inspect }
          next
        end

        first_two = digits[0,2]
        unless first_two =~ /\A\d{2}\z/
          msg = "first_two_not_digits"
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> #{msg} ('#{first_two}')" if verbose
          issues << { id: pass.id, sticker_number: sn, reason: msg, details: first_two }
          next
        end

        yy = first_two.to_i
        year_int = 2000 + yy
        unless year_int.between?(min_year, current_year)
          msg = "out_of_range"
          puts "Skipping id=#{pass.id} sticker='#{sn}' -> candidate year=#{year_int} out of range (#{min_year}-#{current_year})" if verbose
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
