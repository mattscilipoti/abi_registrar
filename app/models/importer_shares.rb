require 'csv'
require_relative 'importer'

class ImporterShares < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      properties_not_found: 0,
      residencies_not_found: 0,
      shares_created: 0,
      shares_updated: 0,
      shares_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    share_transaction = import_shares(row_info)
  end

  def import_shares(row_info)
    share_count = row_info.fetch(:abishares)
    if share_count.blank?
      import_info[:rows_skipped] += 1
      announce("SKIPPED: No Shares Listed #{ {row: @row_index, tax_id: row_info[:taxid]} }".gray, row_index: @row_index, prefix: "⏩") 
      return
    end

    property = Property.find_by(property_find_by(row_info))
    if property.blank?
      import_info[:properties_not_found] += 1
      announce("WARN: Property Not Found! #{ property_find_by(row_info) }".red, row_index: @row_index, prefix: "❌") 
      return
    end

    # WORKAROUND: during import, we do NOT know which resident purchased the sharres
    #  AND we don't know which (newly-imported) Resident is a Deed Holder, yet.
    #  So we select the first one.    
    residency = property.residencies.first

    if residency.blank?
      announce("WARN: Residency Not Found for Property! #{ property_find_by(row_info) }".red, row_index: @row_index, prefix: "❌")
      import_info[:residencies_not_found] += 1
      return
    end

    shares_find_by = { 
      quantity: row_info.fetch(:abishares),
      activity: :import,
      residency_id: residency.id,
    }

    shares_info = shares_find_by.merge(
      transacted_at: import_info.fetch(:time_start),
    )
    
    import_model(
      ShareTransaction,
      find_by: shares_find_by,
      model_attributes: shares_info,
      association_name: 'shares'
    )
  end
end
