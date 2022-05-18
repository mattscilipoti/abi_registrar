require 'csv'
require_relative 'importer'

class ImporterMembers < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      lots_created: 0,
      lots_updated: 0,
      lots_unchanged: 0,
      properties_created: 0,
      properties_updated: 0,
      properties_unchanged: 0,
      residents_created: 0,
      residents_updated: 0,
      residents_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    lot = import_lot(row_info)
    property = import_property(row_info, lot)
    resident1 = import_resident1(row_info, property)
    resident2 = import_resident2(row_info, property)
  end

  def import_lot(row_info)
    tax_id_parts = parse_tax_id(row_info.fetch(:taxid))
    lot_info = { lot_number: row_info.fetch(:lot) }.merge(tax_id_parts)

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

  def import_resident1(row_info, property)
    resident_info = {
      last_name: row_info.fetch(:ln1),
      first_name: row_info.fetch(:fn1),
      middle_name: row_info.fetch(:mn1),
      email_address: row_info.fetch(:email1),
    }
    resident1 = import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Resident1',
    )

    # Handle association
    # Using "to_s" to hanlde null
    if !resident1.properties.find{|p| p.street_number.to_s.casecmp?(property.street_number) && p.street_name.to_s.casecmp?(property.street_name) }
      resident1.properties << property # saves association
      import_info[:residents_updated] += 1
      announce("Resident1 Property Assigned #{ {id: resident1.id, property_ids: resident1.property_ids } }", row_index: @row_index, prefix: "💾")
    end
    resident1
  end

  def import_resident2(row_info, property)
    resident_info = {
      last_name: row_info.fetch(:ln2),
      first_name: row_info.fetch(:fn2),
      middle_name: row_info.fetch(:mn2),
      email_address: row_info.fetch(:email2),
    }

    # Resident2 may not exist
    if resident_info[:last_name].blank?
      announce('Resident2 Skipped, no Last Name'.gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    resident2 = import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Resident2',
    )

    # Handle association
    # Using "to_s" to hanlde null
    if !resident2.properties.find{|p| p.street_number.to_s.casecmp?(property.street_number) && p.street_name.to_s.casecmp?(property.street_name) }
      resident2.properties << property # saves association
      import_info[:residents_updated] += 1
      announce("Resident2 Property Assigned #{ {id: resident2.id, property_ids: resident2.property_ids } }", row_index: @row_index, prefix: "💾")
    end
    resident2
  end

  # Parses a tax id in a hash of its component parts
  def parse_tax_id(tax_id)
    district, subdivision, account_number = tax_id.split(' ')
    {district: district, subdivision: subdivision, account_number: account_number}
  end
end
