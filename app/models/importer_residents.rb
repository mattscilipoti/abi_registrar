require 'csv'
require_relative 'importer'

class ImporterResidents < Importer
  def initialize(source_file)
    super

    import_info.merge!({
      residents_created: 0,
      residents_updated: 0,
      residents_unchanged: 0,
    })
  end

  # Template Method, called from import_via_csv
  def import_row(row_info)
    property = find_property(row_info)
    resident1 = import_resident1(row_info, property)
    resident2 = import_resident2(row_info, property)
  end


  def find_property(row_info)
    property_info = {
      street_number: row_info.fetch(:phouse),
      street_name: row_info.fetch(:pstreet),
    }
    Property.find_by!(property_info)
  end

  def import_resident1(row_info, property)
    resident_info = {
      last_name: row_info.fetch(:ln1),
      first_name: row_info.fetch(:fn1),
      middle_name: row_info.fetch(:mn1),
      email_address: row_info.fetch(:email1),
      phone: row_info.fetch(:primphone),
    }
    resident1 = import_model(
      Resident,
      model_attributes: resident_info,
      label: 'Resident1',
    )
    import_info[:residents_created] += 1

    # Handle association
    # Using "to_s" to handle null
    if !resident1.properties.find{|p| p.street_number.to_s.casecmp?(property.street_number) && p.street_name.to_s.casecmp?(property.street_name) }
      # assign primary or second home
      is_primary_residence = resident1.primary_residence.nil?
      resident_status = case property.residencies.size
                        when 0
                          :owner
                        else
                          :coowner
                        end
      resident1.residencies.create!(
        property: property,
        primary_residence: is_primary_residence,
        resident_status: resident_status,
      ) # saves association
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
      phone: row_info.fetch(:altphone),
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
    import_info[:residents_created] += 1

    # Handle association
    # Using "to_s" to handle null
    if !resident2.properties.find{|p| p.street_number.to_s.casecmp?(property.street_number) && p.street_name.to_s.casecmp?(property.street_name) }
      # assign primary or second home
      primary_residence = resident2.primary_residence.nil?
      resident2.residencies.create!(property: property, primary_residence: primary_residence) # saves association
      import_info[:residents_updated] += 1
      announce("Resident2 Property Assigned #{ {id: resident2.id, property_ids: resident2.property_ids } }", row_index: @row_index, prefix: "💾")
    end
    resident2
  end
end
