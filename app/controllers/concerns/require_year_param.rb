# frozen_string_literal: true

module RequireYearParam
  extend ActiveSupport::Concern

  included do
    before_action :ensure_year_param
  end

  private

  def ensure_year_param
    return if params.key?(:year)

    # Redirect to same path with current year param appended.
    redirect_to url_for(params.permit!.to_h.merge(year: Time.zone.now.year)), allow_other_host: false
  end
end
