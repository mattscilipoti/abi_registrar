# frozen_string_literal: true

module RequireYearParam
  extend ActiveSupport::Concern

  included do
    # Only enforce the year param on safe GET requests. Previously this
    # ran for all verbs which caused non-GET requests (like PATCH/PUT for
    # updates) to be redirected before the controller action ran, dropping
    # form submissions and preventing validation errors from being shown.
    before_action :ensure_year_param, if: -> { request.get? }
  end

  private

  def ensure_year_param
    return if params.key?(:year)

    # Redirect to same path with current year param appended.
    redirect_to url_for(params.permit!.to_h.merge(year: AppSetting.current_season_year)), allow_other_host: false
  end
end
