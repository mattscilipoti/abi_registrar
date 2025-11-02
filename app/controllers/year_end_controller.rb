class YearEndController < ApplicationController
  def index

  end

  def reset_fees
    # Capture the configured season before running year-end so we can
    # show a helpful flash message about what changed.
    previous_season = AppSetting.current_season_year

    YearEnd.reset_fees

    new_season = AppSetting.current_season_year
    if new_season != previous_season
      flash[:notice] = "Year-end completed: season advanced from #{previous_season} to #{new_season}. Fees and amenity processed markers were reset."
    else
      flash[:notice] = 'Year-end completed: fees and amenity processed markers were reset.'
    end

    redirect_to year_end_url
  rescue StandardError => e
    logger.error "YearEnd reset_fees failed: #{e.class} - #{e.message}\n#{e.backtrace.take(10).join("\n")}" if defined?(logger)
    flash[:alert] = 'There was a problem resetting fees. Please check data and try again.'
    redirect_to year_end_url
  end
end
