require 'csv'
require_relative 'importer'

class ImporterProperties < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      properties_created: 0,
      properties_updated: 0,
      properties_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    logger.debug "Importing Property: #{row_info}..."
    lot = find_lot(row_info)

    property = import_property(row_info, lot)
  end

  def find_lot(row_info)
    tax_id_parts = parse_tax_id(row_info.fetch(:acct))
    Lot.find_by!(tax_id_parts)
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
    # Using "to_s" to handle null
    if !property.lots.find{|l| l.tax_identifier.to_s.casecmp?(lot.tax_identifier) }
      property.lots << lot # saves association
      property.update_attribute(:membership_eligible, property.lots.any?(&:membership_eligible?))
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
