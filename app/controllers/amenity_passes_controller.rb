class AmenityPassesController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
    amenity_passes = filter_models(AmenityPass, params[:q])
    @amenity_passes = amenity_passes.decorate
  end
end
