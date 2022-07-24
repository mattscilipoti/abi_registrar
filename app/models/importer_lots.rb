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
    p import_info
    p row_info.to_s.truncate(80)
debugger if import_info[:rows_processed] != (import_info[:lots_created] + import_info[:lots_unchanged] + import_info[:lots_updated])
    lot = import_lot(row_info)
    if lot.nil?
      announce('Lot Skipped, nil'.gray, row_index: @row_index, prefix: "⏩".gray)
      return false
    end
    return true
  end

  def import_lot(row_info)
    tax_id = row_info.fetch(:acct)
    tax_id_parts = parse_tax_id(tax_id)
    lot_info = tax_id_parts.merge({
      lot_number: row_info.fetch(:lot),
      section: parse_section(row_info),
      tax_identifier: tax_id
    })
    import_model(
      Lot,
      find_by: tax_id_parts,
      model_attributes: lot_info
    )
  end

  def parse_section(row_info)
    section = row_info[:section]
    if !(1..5).cover?(section)
      section = nil
    end
    section
  end

  # Parses a tax id in a hash of its component parts
  def parse_tax_id(tax_id)
    district, subdivision, account_number = tax_id.split(' ')
    {district: district, subdivision: subdivision, account_number: account_number}
  end
end
