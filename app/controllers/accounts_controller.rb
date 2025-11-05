# Helper controller for rodauth acounts
# Only supports Index
class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  # POST /accounts/update_season_year
  def update_season_year
    # Accept values submitted either as top-level params (legacy) or nested under
    # :season_settings (simple_form non-model form). Provide clearer messages
    # describing what went wrong when nothing is updated.
    raw_year = params[:season_year].presence || params.dig(:season_settings, :season_year).presence
    raw_min_year = params[:minimum_season_year].presence || params.dig(:season_settings, :minimum_season_year).presence

    updated = []
    invalid = []

    if raw_year.present?
      if raw_year.to_s.match?(/\A\d+\z/)
        AppSetting.set('current_season_year', raw_year.to_s)
        updated << "current season year to #{raw_year}"
      else
        invalid << "Current season year (#{raw_year})"
      end
    end

    if raw_min_year.present?
      if raw_min_year.to_s.match?(/\A\d+\z/)
        AppSetting.set('minimum_season_year', raw_min_year.to_s)
        updated << "minimum season year to #{raw_min_year}"
      else
        invalid << "Minimum season year (#{raw_min_year})"
      end
    end

    if updated.any?
      redirect_to accounts_path, notice: "Updated: #{updated.join(', ')}"
    elsif invalid.any?
      redirect_to accounts_path, alert: "Invalid year format for: #{invalid.join(', ')}. Please enter numeric years like 2025."
    else
      redirect_to accounts_path, alert: 'No season year provided. Please enter a numeric year for Current season year or Minimum season year.'
    end
  end
end
