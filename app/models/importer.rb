require 'csv'

class Importer
  attr_accessor :import_info
  attr_reader :source_file
  def initialize(source_file)
    @row_index = 0
    @source_file = Pathname.new(source_file)
    raise ArgumentError, "source_file does not exist: '#{@source_file}'" unless @source_file.exist?
    @import_info = {
      rows_processed: 0,
      rows_skipped: 0,
    }
  end

  def announce(message, row_index: nil, prefix: nil, data: {})
    msg_info = []
    msg_info << "#{"%04d" % row_index}" if row_index
    msg_info << prefix if prefix
    msg_info << message

    puts msg_info.compact.join(' ') if msg_info.present?
    ap data if data.present?
  end

  def import(range: nil)
    puts "Importing data from '#{source_file}'"
    converted_range = range.nil? ? nil : Range.new(*range.split("..").map(&:to_i))
    import_info.merge!({
      time_start: Time.now,
    })

    results = import_via_csv(range: converted_range)

    time_end = Time.now
    duration = ActiveSupport::Duration.build(time_end - import_info.fetch(:time_start))
    import_info.merge!({
      time_end: time_end,
      time_duration: duration,
    })
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

    import_info.merge!({
      count: table.count,
      range: range,
    })

    announce "\nSummary:", data: import_info

    announce "\nImporting #{range if range.inspect}:"

    @row_index = range ? range.begin : 1
    table_rows =  if range
                    table[range]
                  else
                    table
                  end

    table_rows.each do |row_info|
      import_row(row_info)
      @row_index += 1
      import_info[:rows_processed] += 1
    end
    import_info
  end

  def import_row
    raise NotImplementedError, "Template method, must be populated in child class"
  end

  def import_model(model_class, model_attributes:, find_by: model_attributes, association_name: model_class.table_name, label: model_class.name)
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

  def property_find_by(row_info)
    { 
      street_number: row_info.fetch(:phouse), 
      street_name: row_info.fetch(:pstreet)
    }
  end

  def resident_find_by(row_info)
    {
      last_name: row_info.fetch(:ln1),
      first_name: row_info.fetch(:fn1),
      middle_name: row_info.fetch(:mn1),
    }
  end
end
