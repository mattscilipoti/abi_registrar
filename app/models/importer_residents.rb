require 'csv'
require 'ruby_postal/parser'
require 'wannabe_bool'
require_relative 'importer'

class ImporterResidents < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      resident_mailing_address_assigned: 0,
      resident_notes_added: 0,
      resident_notes_skipped: 0,
      residents_created: 0,
      residents_updated: 0,
      residents_unchanged: 0,
      property_notes_added: 0,
      property_notes_skipped: 0,
    })
  end

  def add_notes_to_property(property, row_info)
    notes = row_info.fetch(:notes)
    if notes.blank?
      import_info[:property_notes_skipped] += 1
      announce("Property Notes Skipped (blank)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    if property.comments.any?{|comment| comment.content == notes}
      import_info[:property_notes_skipped] += 1
      announce("Property Notes Skipped (exists)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    property.comments.create!(content: notes)
    import_info[:property_notes_added] += 1
    announce("Property Notes Added (as Comment) #{ {id: property.id, notes: notes.truncate(20) } }", row_index: @row_index, prefix: "💾")
  end

  def assign_alternate_email_as_comment(resident, row_info)
    alt_email = row_info.fetch(:alt_email)
    if alt_email.blank?
      import_info[:resident_notes_skipped] += 1
      announce("Resident Alt. Email Skipped (blank)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    if resident.comments.any?{|comment| comment.content == alt_email}
      import_info[:resident_notes_skipped] += 1
      announce("Resident Alt. Email Skipped (exists)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    resident.comments.create!(content: "Alternate email: #{alt_email}")
    import_info[:resident_notes_added] += 1
    announce("Resident Alt. Email Added (as Comment) #{ {id: resident.id, alt_email: alt_email.truncate(20) } }", row_index: @row_index, prefix: "💾")
  end

  def assign_alternate_phone_as_comment(resident, row_info)
    alt_phone = row_info.fetch(:alt_phone)
    if alt_phone.blank?
      import_info[:resident_notes_skipped] += 1
      announce("Resident Alt. Phone Skipped (blank)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    if resident.comments.any?{|comment| comment.content == alt_phone}
      import_info[:resident_notes_skipped] += 1
      announce("Resident Alt. Phone Skipped (exists)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end

    resident.comments.create!(content: "Alternate phone: #{alt_phone}")
    import_info[:resident_notes_added] += 1
    announce("Resident Alt. Phone Added (as Comment) #{ {id: resident.id, alt_phone: alt_phone.truncate(20) } }", row_index: @row_index, prefix: "💾")
  end

  def assign_mailing_address(resident, row_info)
    mail_address = row_info.fetch(:mailing_address)

    if mail_address.nil?
      announce("Resident Mailing Address Skipped (blank)".gray, row_index: @row_index, prefix: "⏩".gray)
      return
    end
    address = Postal::Parser.parse_address(mail_address)
    formatted_address = address.inject({}) do |address_items, address_item|
      address_items[address_item.fetch(:label)] = address_item.fetch(:value).upcase
      address_items
    end

    resident.update_attribute(:mailing_address, formatted_address)
    import_info[:resident_mailing_address_assigned] += 1
    announce("Resident Mailing Address assigned #{ { id: resident.id, mailing_address: address.to_s.truncate(20) } }", row_index: @row_index, prefix: "💾")
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
      assign_alternate_email_as_comment(owner, row_info)
      assign_alternate_phone_as_comment(owner, row_info)
      assign_mailing_address(owner, row_info)
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

    import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Owner',
    )
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
      last_name: parts[0].to_s.strip,
      first_name: parts[1].to_s.strip,
      middle_name: parts[2..-1].join(' ').to_s.strip
    }
  end
end
