class BoatRampAccessPassesController < ApplicationController
  before_action :set_boat_ramp_access_pass, only: %i[ show edit update destroy ]

  # GET /boat_ramp_access_passes or /boat_ramp_access_passes.json
  def index
    boat_ramp_access_passes = filter_models(BoatRampAccessPass, params[:q])
    @boat_ramp_access_passes = boat_ramp_access_passes.decorate
  end

  # GET /boat_ramp_access_passes/1 or /boat_ramp_access_passes/1.json
  def show
  end

  # GET /boat_ramp_access_passes/new
  def new
    @boat_ramp_access_pass = BoatRampAccessPass.new
  end

  # GET /boat_ramp_access_passes/1/edit
  def edit
  end

  # POST /boat_ramp_access_passes or /boat_ramp_access_passes.json
  def create
    @boat_ramp_access_pass = BoatRampAccessPass.new(boat_ramp_access_pass_params)

    respond_to do |format|
      if @boat_ramp_access_pass.save
        format.html { redirect_to boat_ramp_access_pass_url(@boat_ramp_access_pass), notice: "Boat Ramp Access Pass was successfully created." }
        format.json { render :show, status: :created, location: @boat_ramp_access_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @boat_ramp_access_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_ramp_access_passes/1 or /boat_ramp_access_passes/1.json
  def update
    respond_to do |format|
      if params[:boat_ramp_access_pass] && params[:boat_ramp_access_pass][:voided]
        if params[:boat_ramp_access_pass][:voided] == '1'
          params[:boat_ramp_access_pass][:voided_at] = Time.current
        else
          params[:boat_ramp_access_pass][:voided_at] = nil
        end
        params[:boat_ramp_access_pass].delete(:voided)
      end
      if @boat_ramp_access_pass.update(boat_ramp_access_pass_params)
        format.html { redirect_to boat_ramp_access_pass_url(@boat_ramp_access_pass), notice: "Boat Ramp Access Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @boat_ramp_access_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @boat_ramp_access_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_ramp_access_passes/1 or /boat_ramp_access_passes/1.json
  def destroy
    @boat_ramp_access_pass.destroy

    respond_to do |format|
      format.html { redirect_to boat_ramp_access_passes_url, notice: "Boat Ramp Access Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_ramp_access_pass
      @boat_ramp_access_pass = BoatRampAccessPass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def boat_ramp_access_pass_params
      params.require(:boat_ramp_access_pass).permit(
        :resident_id,
        :description,
        :location,
        :state_code,
        :tag_number,
        :sticker_number,
        :voided_at,
      )
    end
end
