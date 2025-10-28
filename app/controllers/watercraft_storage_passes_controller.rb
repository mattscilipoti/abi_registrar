class WatercraftStoragePassesController < ApplicationController
  include RequireYearParam
  before_action :set_watercraft_storage_pass, only: %i[ show edit update destroy ]

  # GET /watercraft_storage_passes or /watercraft_storage_passes.json
  def index
    watercraft_storage_passes = filter_models(WatercraftStoragePass, params[:q])
    @year = params[:year]
    @watercraft_storage_passes = watercraft_storage_passes.by_year(@year)
                                                          .includes(resident: :residencies) # preload relationships used by decorators/views
                                                          .decorate
  end

  # GET /watercraft_storage_passes/1 or /watercraft_storage_passes/1.json
  def show
  end

  # GET /watercraft_storage_passes/new
  def new
    @watercraft_storage_pass = WatercraftStoragePass.new
  end

  # GET /watercraft_storage_passes/1/edit
  def edit
  end

  # POST /watercraft_storage_passes or /watercraft_storage_passes.json
  def create
    @watercraft_storage_pass = WatercraftStoragePass.new(watercraft_storage_pass_params)

    respond_to do |format|
      if @watercraft_storage_pass.save
        format.html { redirect_to watercraft_storage_pass_url(@watercraft_storage_pass), notice: "Watercraft Storage Pass was successfully created." }
        format.json { render :show, status: :created, location: @watercraft_storage_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @watercraft_storage_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watercraft_storage_passes/1 or /watercraft_storage_passes/1.json
  def update
    respond_to do |format|
      if @watercraft_storage_pass.update(watercraft_storage_pass_params)
        format.html { redirect_to watercraft_storage_pass_url(@watercraft_storage_pass), notice: "Watercraft Storage Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @watercraft_storage_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @watercraft_storage_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watercraft_storage_passes/1 or /watercraft_storage_passes/1.json
  def destroy
    @watercraft_storage_pass.destroy

    respond_to do |format|
      format.html { redirect_to watercraft_storage_passes_url, notice: "Watercraft Storage Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watercraft_storage_pass
      @watercraft_storage_pass = WatercraftStoragePass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def watercraft_storage_pass_params
      params.require(:watercraft_storage_pass).permit(
        :resident_id,
        :beach_number,
        :description,
        :location,
        :sticker_number,
      )
    end
end
