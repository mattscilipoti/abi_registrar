  class ResidencyDecorator < Draper::Decorator
    delegate_all

    def property_summary
      "#{object.property.to_s} (#{resident_status_i18n})"
    end

    def resident_status_i18n
      resident_status.try(:titleize) || "⁇"
    end

    def resident_summary
      "#{object.resident.full_name} (#{resident_status_i18n})"
    end
  end
