class BeachPassesController < ApplicationController
  include RequireYearParam
  before_action :set_beach_pass, only: %i[ show edit update destroy ]

  # GET /beach_passes or /beach_passes.json
  def index
    beach_passes = filter_models(BeachPass, params[:q])
    @year = params[:year]
    @beach_passes = beach_passes.by_year(@year).decorate
  end

  # GET /beach_passes/1 or /beach_passes/1.json
  def show
  end

  # GET /beach_passes/new
  def new
    @beach_pass = BeachPass.new
  end

  # GET /beach_passes/1/edit
  def edit
  end

  # POST /beach_passes or /beach_passes.json
  def create
    @beach_pass = BeachPass.new(beach_pass_params)

    respond_to do |format|
      if @beach_pass.save
        format.html { redirect_to beach_pass_url(@beach_pass), notice: "Beach Pass was successfully created." }
        format.json { render :show, status: :created, location: @beach_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beach_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beach_passes/1 or /beach_passes/1.json
  def update
    respond_to do |format|
      if @beach_pass.update(beach_pass_params)
        format.html { redirect_to beach_pass_url(@beach_pass), notice: "Beach Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @beach_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beach_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beach_passes/1 or /beach_passes/1.json
  def destroy
    @beach_pass.destroy

    respond_to do |format|
      format.html { redirect_to beach_passes_url, notice: "Beach Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beach_pass
      @beach_pass = BeachPass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def beach_pass_params
      params.require(:beach_pass).permit(
        :resident_id,
        :description,
        :sticker_number,
      )
    end
end
