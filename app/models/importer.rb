require 'csv'

class Importer
  attr_accessor :import_info
  attr_reader :source_file
  def initialize(source_file)
    @source_file = Pathname.new(source_file)
    raise ArgumentError, "source_file does not exist: '#{@source_file.realpath}'" unless @source_file.exist?
  end

  def import(range: nil)
    puts "Loading Membership info from..."
    results = import_via_csv(range: range)
    announce "\nDone", data: results
  end

  def import_via_csv(range: nil)
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
      row_index: 1,
      lots_created: 0,
      lots_updated: 0,
      lots_unchanged: 0,
      properties_created: 0,
      properties_updated: 0,
      properties_unchanged: 0,
    }
    announce "Summary:", data: import_info
    announce "Importing..."
    table_rows =  if range
                    converted_range = Range.new(*range.split("..").map(&:to_i))
                    table[converted_range]
                  else
                    table
                  end

    table_rows.each do |row_info|
      lot = import_lot(row_info)
      property = import_property(row_info, lot)
      import_info[:row_index] += 1
    end
    import_info
  end

  def import_lot(row_info)
    import_model(
      Lot,
      find_by: {lot_number: row_info.fetch(:lot)},
      model_attributes: parse_lot_info(row_info)
    )
  end

  def import_model(model_class, model_attributes:, find_by: model_attributes, association_name: model_class.table_name)
    # find_by ||= model_attributes
    # association_name ||= model_class.table_name # e.g. properties
    model = model_class.find_by(find_by)

    if model
      model.assign_attributes(model_attributes)

      if model.changed?
        model.save!
        import_info["#{association_name}_updated".to_sym] += 1
        announce("#{model_class} Updated #{ {id: model.id} }...", row_index: import_info[:row_index], prefix: "💾".blue, data: model.changes)
      else
        import_info["#{association_name}_unchanged".to_sym] += 1
        announce("#{model_class} Unchanged #{ {id: model.id} }", row_index: import_info[:row_index], prefix: "⏩".gray)
      end
    else
      # Create a new model
      # e.g. lot.property = property
      model = model_class.create!(model_attributes)
      announce "#{model_class} Created #{ {id: model.id} }", row_index: import_info[:row_index], data: model_attributes, prefix: "🆕"

      import_info["#{association_name}_created".to_sym] += 1
    end

    model
  end

  def import_property(row_info, lot)
    property = import_model(
      Property,
      model_attributes: parse_property_info(row_info, lot),
    )

    # Handle association
    # e.g. lot.properties != property
    if lot.property != property
      property.lots << lot # saves association
      import_info[:properties_updated] += 1
      announce("Property Lot Assigned #{ {id: property.id, lot_ids: property.lot_ids } }", row_index: import_info[:row_index], prefix: "💾".blue)
    end
  end

  def import_via_roo
    require 'roo'
    csv = Roo::Spreadsheet.open(source_file.to_s, csv_options: {headers: true})
    puts csv.info
    sheet = csv.sheet('default') # only one sheet
    rows_to_import = sheet.last_row
    row_index = 0
  debugger
    sheet.each(tax_id: 'TAXID', lot_number: 'LOT') do |lot_info|
      row_index += 1
      lot = Lot.find_by(lot_number: lot_info.fetch(:lot_number))
      if lot
        announce("already exists", row_index: row_index, prefix: "SKIP".blue, data: lot_info)
        next
      end

    end
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
    tax_id_parts = parse_tax_id(row_info.fetch(:taxid))
    { lot_number:  row_info.fetch(:lot) }.merge(tax_id_parts)
  end

  def parse_property_info(row_info, lot)
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
