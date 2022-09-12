require 'csv'
require 'wannabe_bool'
require_relative 'importer'

class ImporterResidents < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      residents_created: 0,
      residents_updated: 0,
      residents_unchanged: 0,
      property_notes_added: 0,
      property_notes_skipped: 0,
    })
  end

  def add_notes_to_property(property, row_info)
    notes = row_info.fetch(:notes)
    return if notes.blank?

    if property.comments.any?{|comment| comment.content == notes}
      import_info[:property_notes_skipped] += 1
      announce("#{resident_status.to_s.humanize} Property Notes Skipped (blank)".gray, row_index: @row_index, prefix: "⏩".gray)
    else
      property.comments.create!(content: notes)
      import_info[:property_notes_added] += 1
      announce("Property Notes Added #{ {id: property.id, notes: notes.truncate(20) } }", row_index: @row_index, prefix: "💾")
    end
  end

  def assign_to_property(resident, property, resident_status, row_info)
    return if resident.nil?

    # Handle association
    # Using "to_s" to handle null
    if !resident.properties.find{|p| p.tax_id.to_s == property.tax_id }
      # assign primary or second home
      is_primary_residence = row_info.fetch(:prin_res).to_boolean

      resident.residencies.create!(
        property: property,
        primary_residence: is_primary_residence,
        resident_status: resident_status,
      ) # saves association
      import_info[:residents_updated] += 1
      announce("#{resident_status.to_s.humanize} Property Assigned #{ {id: resident.id, property_ids: resident.property_ids } }", row_index: @row_index, prefix: "💾")
    end
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    # ap "DEBUG:"
    # ap row_info

    property = find_property(row_info)
    add_notes_to_property(property, row_info)

    import_owner(row_info, property).tap do |owner|
      assign_to_property(owner, property, :owner, row_info)
    end
    import_coowner(row_info, property).tap do |coowner|
      assign_to_property(coowner, property, :coowner, row_info)
    end
  end

  def find_property(row_info)
    property_info = {
      tax_identifier: row_info.fetch(:account),
    }
    Property.find_by!(property_info)
  end

  def import_owner(row_info, property)
    name_info = parse_name(row_info.fetch(:owner))
    resident_info = name_info.merge({
      email_address: row_info.fetch(:prim_email),
      phone: row_info.fetch(:prim_phone),
    })

    owner = import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Owner',
    )
    import_info[:residents_created] += 1
    owner
  end

  def import_coowner(row_info, property)
    name_info = parse_name(row_info.fetch(:coowner))
    resident_info = name_info.merge({
      email_address: row_info.fetch(:second_email),
      phone: row_info.fetch(:second_phone),
    })

    # Co-owner may not exist
    if resident_info[:last_name].blank?
      announce('Co-owner Skipped, no Last Name'.gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    coowner = import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Co-owner',
    )
    import_info[:residents_created] += 1
    coowner
  end

  def parse_name(full_name)
    return {} if full_name.blank?

    parts = full_name.split(' ')
    {
      last_name: parts[0],
      first_name: parts[1],
      middle_name: parts[2..-1].join(' ')
    }
  end
end
