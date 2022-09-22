require 'csv'
require_relative 'importer'

class ImporterLots < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      lots_created: 0,
      lots_updated: 0,
      lots_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    logger.debug "Importing Lot: #{row_info}..."
    # p import_info
    # p row_info.to_s.truncate(80)
    # debugger if import_info[:rows_processed] != (import_info[:lots_created] + import_info[:lots_unchanged] + import_info[:lots_updated])
    lots = row_info.fetch(:lot_s).to_s.split(',')

    if lots.empty?
      import_info[:rows_skipped] += 1
      announce('Lot(s) Skipped, nil'.gray, row_index: @row_index, prefix: "⏩".gray)
      return false
    end

    lots.each do |lot_number|
      total_lot_count = row_info.fetch(:total_lots)
      # partial lots will be handled manually
      lot_size = (total_lot_count == total_lot_count.to_i) ? total_lot_count.to_f / (lots.size || 1) : nil

      find_lot = { lot_number: lot_number }
      import_model(
        Lot,
        find_by: find_lot,
        model_attributes: find_lot.merge(size: lot_size)
      )
    end
    return true
  end
end
