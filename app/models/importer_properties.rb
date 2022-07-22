require 'csv'
require_relative 'importer'

class ImporterProperties < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      lots_created: 0,
      lots_updated: 0,
      lots_unchanged: 0,
      properties_created: 0,
      properties_updated: 0,
      properties_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    lot = import_lot(row_info)
    if lot.nil?
      announce('Lot Skipped, nil'.gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end
    property = import_property(row_info, lot)
  end

  def import_lot(row_info)
    # logger.debug "Importing #{row_info}..."
    if row_info.fetch(:section) == 0 ## Not in Arden?
      announce('Lot Skipped, Section: 0'.gray, row_index: @row_index, prefix: "⏩".gray)
      return nil
    end

    tax_id_parts = parse_tax_id(row_info.fetch(:acct))
debugger unless (1..5).cover?(row_info.fetch(:section))
    lot_info = tax_id_parts.merge({
      lot_number: row_info.fetch(:lot),
      section: row_info.fetch(:section),
    })
    import_model(
      Lot,
      find_by: {lot_number: row_info.fetch(:lot)},
      model_attributes: lot_info
    )
  end

  def import_property(row_info, lot)
    property_info = {
      street_number: row_info.fetch(:phouse),
      street_name: row_info.fetch(:pstreet),
    }
    property = import_model(
      Property,
      model_attributes: property_info,
    )

    # Handle association
    # Using "to_s" to hanlde null
    if !property.lots.find{|l| l.lot_number.to_s.casecmp?(lot.lot_number) }
      property.lots << lot # saves association
      import_info[:properties_updated] += 1
      announce("Property Lot Assigned #{ {id: property.id, lot_ids: property.lot_ids } }", row_index: @row_index, prefix: "💾")
    end
    property
  end

  # Parses a tax id in a hash of its component parts
  def parse_tax_id(tax_id)
    district, subdivision, account_number = tax_id.split(' ')
    {district: district, subdivision: subdivision, account_number: account_number}
  end
end
