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

  def assign_lots(property, lot_numbers)
    # Handle association
    # Using "to_s" to handle null
    return if lot_numbers.empty?

    lot_ids = lot_numbers.collect{|lot_number| Lot.find_by!(lot_number: lot_number).id }
    property.lot_ids = lot_ids
    import_info[:properties_updated] += 1
    announce("Property Lot(s) Assigned #{ {id: property.id, lot_ids: property.lot_ids } }", row_index: @row_index, prefix: "💾")
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    logger.debug "Importing Property: #{row_info}..."

    import_property(row_info).tap do |property|
      lot_numbers = row_info.fetch(:lot_s).to_s.split(',')
      assign_lots(property, lot_numbers)
    end
  end

  def import_property(row_info)
# debugger
    property_info = {
      # comment: row_info.fetch(:notes),
      membership_eligible: true,
      section: row_info.fetch(:section),
      street_number: row_info.fetch(:house),
      street_name: row_info.fetch(:street_name),
      tax_identifier: row_info.fetch(:account),
    }

    property = import_model(
      Property,
      model_attributes: property_info,
    )
    import_info[:properties_created] += 1
    property
  end
end
