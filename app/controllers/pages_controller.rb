class PagesController < ApplicationController
  skip_before_action :authenticate, only: [:home]

  def home
    if rodauth.logged_in?
      redirect_to summary_path(q: '🚫')
    else
      redirect_to amenity_passes_path(q: '🚫')
    end
  end

  def summary
  end
end
