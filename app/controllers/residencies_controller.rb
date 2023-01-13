class ResidenciesController < ApplicationController
  before_action :set_residency, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, :only => [:update]

  # GET /residencies or /residencies.json
  def index
    residencies = filter_models(Residency, params[:q])
    @residencies = residencies.decorate
  end

  # GET /residencies/1 or /residencies/1.json
  def show
  end

  # PATCH/PUT /residencies/1 or /residencies/1.json
  def update
    respond_to do |format|
      if @residency.update(residency_params)
        format.html { redirect_to resident_url(@residency.resident), notice: "Residency was successfully updated." }
        format.json { render :show, status: :ok, location: @resident }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @residency.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_residency
      @residency = Residency.find(params[:id])
    end

    def residency_params
      params.require(:residency).permit(
        :resident_status,
        :verified_on
      )
    end
end
