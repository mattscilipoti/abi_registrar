module ResidentsHelper
  def resident_status_character(resident_status, is_minor)
    # debugger
    return '' if is_minor # child

    case resident_status
    when nil
      '⁇'
    when :border.to_s
      '' # people-robbery
    when /owner/, :trustee.to_s
      '' # gavel
    when :renter.to_s
      '' # suitcase
    when :dependent.to_s
      # '' # family, pro
      '' # user-graduate
    when :significant_other.to_s
      '' # user-group
    else
      raise NotImplementedError, "Unknown resident_status: #{resident_status.inspect}"
    end
  end
end
