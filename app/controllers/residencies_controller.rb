class ResidenciesController < ApplicationController
  before_action :set_residency, only: %i[ show edit update destroy ]

  # GET /residencies or /residencies.json
  def index
    residencies = filter_models(Residency, params[:q])
    @residencies = residencies.decorate
  end

  # GET /residencies/1 or /residencies/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_residency
      @residency = Resident.find(params[:id])
    end
end
