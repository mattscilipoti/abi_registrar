module AmenityPassHelper
  def voided_info_tag(amenity_pass)
    if amenity_pass.voided_at?
      content_tag(:div, class: 'voided-info') do
        concat content_tag(:strong, 'Voided At:')
        concat '&nbsp;'.html_safe
        concat content_tag(:span, amenity_pass.voided_at)
        concat ',&nbsp;'.html_safe
        concat content_tag(:strong, 'Voided Reason:')
        concat '&nbsp;'.html_safe
        concat content_tag(:span, amenity_pass.voided_reason)
      end
    else
      content_tag(:div, class: 'not-voided-info') do
        concat content_tag(:strong, 'Not Voided')
      end
    end
  end
end
