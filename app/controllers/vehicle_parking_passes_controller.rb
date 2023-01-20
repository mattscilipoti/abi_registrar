class VehicleParkingPassesController < ApplicationController
  before_action :set_vehicle_parking_pass, only: %i[ show edit update destroy ]

  # GET /vehicle_parking_passes or /vehicle_parking_passes.json
  def index
    vehicle_parking_passes = filter_models(VehicleParkingPass, params[:q])
    @vehicle_parking_passes = vehicle_parking_passes.decorate
  end

  # GET /vehicle_parking_passes/1 or /vehicle_parking_passes/1.json
  def show
  end

  # GET /vehicle_parking_passes/new
  def new
    @vehicle_parking_pass = VehicleParkingPass.new
  end

  # GET /vehicle_parking_passes/1/edit
  def edit
  end

  # POST /vehicle_parking_passes or /vehicle_parking_passes.json
  def create
    @vehicle_parking_pass = VehicleParkingPass.new(vehicle_parking_pass_params)

    respond_to do |format|
      if @vehicle_parking_pass.save
        format.html { redirect_to vehicle_parking_pass_url(@vehicle_parking_pass), notice: "Vehicle Parking Pass was successfully created." }
        format.json { render :show, status: :created, location: @vehicle_parking_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vehicle_parking_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_parking_passes/1 or /vehicle_parking_passes/1.json
  def update
    respond_to do |format|
      if @vehicle_parking_pass.update(vehicle_parking_pass_params)
        format.html { redirect_to vehicle_parking_pass_url(@vehicle_parking_pass), notice: "Vehicle Parking Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @vehicle_parking_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vehicle_parking_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_parking_passes/1 or /vehicle_parking_passes/1.json
  def destroy
    @vehicle_parking_pass.destroy

    respond_to do |format|
      format.html { redirect_to vehicle_parking_passes_url, notice: "Vehicle Parking Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_parking_pass
      @vehicle_parking_pass = VehicleParkingPass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_parking_pass_params
      params.require(:vehicle_parking_pass).permit(
        :resident_id,
        :state_code,
        :sticker_number,
        :tag_number
      )
    end
end
