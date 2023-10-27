class YearEndController < ApplicationController
  def index

  end

  def reset_fees
    YearEnd.reset_fees
    flash[:notice] = 'All fees reset.'
    redirect_to year_end_url
  rescue
    flash[:alert] = 'There was a problem reseting fees. Please check data and try again, if needed.'
    redirect_to year_end_url
  end
end
