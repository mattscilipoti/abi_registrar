class AmenityPassesController < ApplicationController
  include RequireYearParam

  skip_before_action :authenticate, only: [:index]

  def index
    amenity_passes = filter_models(AmenityPass, params[:q])
    # apply year filter (controller ensures params[:year] exists)
    @year = params[:year]
    @amenity_passes = amenity_passes.by_year(@year).decorate
  end
end
