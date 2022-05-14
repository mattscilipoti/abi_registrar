require 'csv'

class Importer
  attr_accessor :import_info
  attr_reader :source_file
  def initialize(source_file)
    @row_index = 0
    @source_file = Pathname.new(source_file)
    raise ArgumentError, "source_file does not exist: '#{@source_file.realpath}'" unless @source_file.exist?
  end

  def import(range: nil)
    puts "Loading Membership info from..."
    converted_range = range.nil? ? nil : Range.new(*range.split("..").map(&:to_i))
    results = import_via_csv(range: converted_range)
    announce "\nImport Completed:", data: results
  end

  def import_via_csv(range: nil)
    raise ArgumentError, "range must be a Range" if range && !range.is_a?(Range)

    table = CSV.table(source_file,
      converters: [:integer],
      header_converters: [:downcase, :symbol],
      headers: true,
      skip_blanks: true,
      strip: true,
    )
    table.by_row!



    @import_info = {
      count: table.count,
      range: range,
      rows_processed: 0,
      lots_created: 0,
      lots_updated: 0,
      lots_unchanged: 0,
      properties_created: 0,
      properties_updated: 0,
      properties_unchanged: 0,
      residents_created: 0,
      residents_updated: 0,
      residents_unchanged: 0,
    }
    announce "\nSummary:", data: import_info

    announce "\nImporting #{range if range.inspect}:"

    @row_index = range ? range.begin : 1
    table_rows =  if range
                    table[range]
                  else
                    table
                  end

    table_rows.each do |row_info|
      lot = import_lot(row_info)
      property = import_property(row_info, lot)
      resident1 = import_resident1(row_info, property)
      resident2 = import_resident2(row_info, property)
      @row_index += 1
      import_info[:rows_processed] += 1
    end
    import_info
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

  def import_model(model_class, model_attributes:, find_by: model_attributes, association_name: model_class.table_name, label: model_class.name)
    # find_by ||= model_attributes
    # association_name ||= model_class.table_name # e.g. properties
    model = model_class.find_by(find_by)

    if model
      model.assign_attributes(model_attributes)

      if model.changed?
        model.save!
        import_info["#{association_name}_updated".to_sym] += 1
        announce("#{label} Updated #{ {id: model.id} }...", row_index: @row_index, prefix: "💾", data: model.changes)
      else
        import_info["#{association_name}_unchanged".to_sym] += 1
        announce("#{label} Unchanged #{ {id: model.id} }".gray, row_index: @row_index, prefix: "⏩")
      end
    else
      # Create a new model
      # e.g. lot.property = property
      model = model_class.create!(model_attributes)
      announce "#{label} Created #{ {id: model.id} }", row_index: @row_index, data: model_attributes, prefix: "💙"

      import_info["#{association_name}_created".to_sym] += 1
    end

    model
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
    if !property.lots.find{|l| l.lot_number.casecmp?(lot.lot_number) }
      property.lots << lot # saves association
      import_info[:properties_updated] += 1
      announce("Property Lot Assigned #{ {id: property.id, lot_ids: property.lot_ids } }", row_index: @row_index, prefix: "💾".blue)
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
    if !resident1.properties.find{|p| p.street_number.casecmp?(property.street_number) && p.street_name.casecmp?(property.street_name) }
      resident1.properties << property # saves association
      import_info[:residents_updated] += 1
      announce("Resident1 Property Assigned #{ {id: resident1.id, property_ids: resident1.property_ids } }", row_index: @row_index, prefix: "💾".blue)
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
    if !resident2.properties.find{|p| p.street_number.casecmp?(property.street_number) && p.street_name.casecmp?(property.street_name) }
      resident2.properties << property # saves association
      import_info[:residents_updated] += 1
      announce("Resident2 Property Assigned #{ {id: resident2.id, property_ids: resident2.property_ids } }", row_index: @row_index, prefix: "💾".blue)
    end
    resident2
  end

  def announce(message, row_index: nil, prefix: nil, data: {})
    msg_info = []
    msg_info << "#{"%04d" % row_index}" if row_index
    msg_info << prefix if prefix
    msg_info << message

    puts msg_info.compact.join(' ') if msg_info.present?
    ap data if data.present?
  end

  # Returns a hash of lot info, parsed from the row
  def parse_lot_info(row_info)

  end

  def parse_property_info(row_info)
    {
      street_number: row_info.fetch(:phouse),
      street_name: row_info.fetch(:pstreet),
    }
  end

  # Parses a tax id in a hash of its component parts
  def parse_tax_id(tax_id)
    district, subdivision, account_number = tax_id.split(' ')
    {district: district, subdivision: subdivision, account_number: account_number}
  end
end
