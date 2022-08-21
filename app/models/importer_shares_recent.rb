require 'csv'
require_relative 'importer'

class ImporterSharesRecent < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      properties_not_found: 0,
      residents_not_found: 0,
      residencies_not_found: 0,
      shares_created: 0,
      shares_updated: 0,
      shares_unchanged: 0,
    })
  end

  def address(row_info)
    [row_info.fetch(:house), row_info.fetch(:street_name)].join(' ')
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    case row_info.fetch(:type)
    when /CC/i, /check/i
      share_transaction = import_share_purchase(row_info)
    else
      # TODO: import Transfer, Board earned share
      import_info[:rows_skipped] += 1
      announce("SKIPPED: Unsupported Payment Type #{ {row: @row_index, type: row_info[:type], address: address(row_info)} }".gray, row_index: @row_index, prefix: "⏩")
    end
  end

  def import_share_purchase(row_info)
    shares_find_by = parse_shares_find_by(row_info)
    return if shares_find_by.nil?

    cost = row_info.fetch(:paid).gsub(/[^\d\.]/, '').to_f
    cost_per = cost / shares_find_by.fetch(:quantity)

    shares_info = shares_find_by.merge(
      cost_per: cost_per,
    )

    import_model(
      ShareTransaction,
      find_by: shares_find_by,
      model_attributes: shares_info,
      association_name: 'shares'
    )
  end

  def parse_primary_residency(row_info)
    address = property_search_query(row_info)
    properties = Property.not_test.search_by_address(address) # Remove our test properties

    if properties.blank?
  debugger
      import_info[:properties_not_found] += 1
      announce("WARN: Property Not Found! #{ property_search_query(row_info) }".red, row_index: @row_index, prefix: "❌")
      return
    end

    if properties.size != 1
  debugger
      import_info[:properties_not_found] += 1
      announce("WARN: Too many properties found for #{ property_search_query(row_info) } (#{properties.size} ct.)".red, row_index: @row_index, prefix: "❌")
      return
    end

    property = properties.first

    # WORKAROUND: during import, we do NOT know which resident purchased the sharres
    #  AND we don't know which (newly-imported) Resident is a Deed Holder, yet.
    #  So we select the first one.

    #TODO: new data source has some resident info
    resident_search_query = resident_search_query(row_info)
    residents = property.residents.search_by_name(resident_search_query)

    if residents.blank?
debugger
      announce("WARN: Resident Not Found for Property! #{ property.inspect }".red, row_index: @row_index, prefix: "❌")
      import_info[:residencies_not_found] += 1
      return
    end

    if residents.size != 1
debugger
      import_info[:residents_not_found] += 1
      announce("WARN: Too many residents found for #{{ property: property, residents: resident_search_query }} (#{residents.size} ct.)".red, row_index: @row_index, prefix: "❌")
      return
    end

    resident = residents.first

    primary_residencies = Residency.where(property: property, resident: resident, primary_residence: true)

    if primary_residencies.blank?
      announce("WARN: Primary Residency Not Found for Property! #{{ property: property, resident: resident }}".red, row_index: @row_index, prefix: "❌")
      import_info[:residencies_not_found] += 1
      return
    end

    if primary_residencies.size != 1
      import_info[:residencies_not_found] += 1
      announce("WARN: Too many primary residencies found for #{{ property: property, resident: resident }} (#{residencies.size} ct.)".red, row_index: @row_index, prefix: "❌")
      return
    end

    primary_residency = primary_residencies.first
  end

  def parse_shares_find_by(row_info)
    share_count = row_info.fetch(:shares)
    if share_count.blank?
      import_info[:rows_skipped] += 1
      announce("SKIPPED: No Shares Listed #{ {row: @row_index, address: address(row_info)} }".gray, row_index: @row_index, prefix: "⏩")
      return
    end

    primary_residency = parse_primary_residency(row_info)
    return if primary_residency.nil?

    if row_info[:date].blank?
      import_info[:rows_skipped] += 1
      announce("SKIPPED: No Date Listed #{ {row: @row_index, address: address(row_info)} }".gray, row_index: @row_index, prefix: "⏩")
      return
    end

    # TODO: update timezone when appropriate
    date_in_eastern = "#{row_info.fetch(:date)} -04:00"
    transacted_at = DateTime.strptime(date_in_eastern, "%m/%d/%Y %Z")

    {
      activity: :import,
      quantity: share_count,
      residency_id: primary_residency.id,
      transacted_at: transacted_at,
    }
  end

  def property_find_by(row_info)
    {
      street_number: row_info.fetch(:house),
      street_name: row_info.fetch(:street_name)
    }
  end

  def property_search_query(row_info)
    [row_info.fetch(:house), row_info.fetch(:street_name)].join(' ')
  end

  def resident_find_by(row_info)
    last_name, first_name = row_info.fetch(:l_name_f_name).split(',')
    {
      last_name: last_name,
      first_name: first_name,
      # middle_name: row_info.fetch(:mn1),
    }
  end

  def resident_search_query(row_info)
    row_info.fetch(:l_name_f_name)
  end
end
