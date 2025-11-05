class DinghyDockStoragePassesController < ApplicationController
  include RequireYearParam
  before_action :set_dinghy_dock_storage_pass, only: %i[ show edit update destroy ]

  # GET /dinghy_dock_storage_passes or /dinghy_dock_storage_passes.json
  def index
    dinghy_dock_storage_passes = filter_models(DinghyDockStoragePass, params[:q])
    @year = params[:year]
    @dinghy_dock_storage_passes = dinghy_dock_storage_passes.by_year(@year)
                                                            .includes(resident: :residencies) # preload relationships used by decorators/views
                                                            .decorate
  end

  # GET /dinghy_dock_storage_passes/1 or /dinghy_dock_storage_passes/1.json
  def show
  end

  # GET /dinghy_dock_storage_passes/new
  def new
    @dinghy_dock_storage_pass = DinghyDockStoragePass.new
  end

  # GET /dinghy_dock_storage_passes/1/edit
  def edit
  end

  # POST /dinghy_dock_storage_passes or /dinghy_dock_storage_passes.json
  def create
    @dinghy_dock_storage_pass = DinghyDockStoragePass.new(dinghy_dock_storage_pass_params)

    respond_to do |format|
      if @dinghy_dock_storage_pass.save
        format.html { redirect_to dinghy_dock_storage_pass_url(@dinghy_dock_storage_pass), notice: "Dinghy Dock Storage Pass was successfully created." }
        format.json { render :show, status: :created, location: @dinghy_dock_storage_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dinghy_dock_storage_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dinghy_dock_storage_passes/1 or /dinghy_dock_storage_passes/1.json
  def update
    respond_to do |format|
      if @dinghy_dock_storage_pass.update(dinghy_dock_storage_pass_params)
        format.html { redirect_to dinghy_dock_storage_pass_url(@dinghy_dock_storage_pass), notice: "Dinghy Dock Storage Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @dinghy_dock_storage_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dinghy_dock_storage_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dinghy_dock_storage_passes/1 or /dinghy_dock_storage_passes/1.json
  def destroy
    @dinghy_dock_storage_pass.destroy

    respond_to do |format|
      format.html { redirect_to dinghy_dock_storage_passes_url, notice: "Dinghy Dock Storage Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dinghy_dock_storage_pass
      @dinghy_dock_storage_pass = DinghyDockStoragePass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dinghy_dock_storage_pass_params
      params.require(:dinghy_dock_storage_pass).permit(
        :resident_id,
        :beach_number,
        :description,
        :location,
        :sticker_number,
        :season_year,
      )
    end
end
