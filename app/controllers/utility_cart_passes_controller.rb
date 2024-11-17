class UtilityCartPassesController < ApplicationController
  before_action :set_utility_cart_pass, only: %i[ show edit update destroy ]

  # GET /utility_cart_passes or /utility_cart_passes.json
  def index
    utility_cart_passes = filter_models(UtilityCartPass, params[:q])
    @utility_cart_passes = utility_cart_passes.decorate
  end

  # GET /utility_cart_passes/1 or /utility_cart_passes/1.json
  def show
  end

  # GET /utility_cart_passes/new
  def new
    @utility_cart_pass = UtilityCartPass.new
  end

  # GET /utility_cart_passes/1/edit
  def edit
  end

  # POST /utility_cart_passes or /utility_cart_passes.json
  def create
    @utility_cart_pass = UtilityCartPass.new(utility_cart_pass_params)

    respond_to do |format|
      if @utility_cart_pass.save
        format.html { redirect_to utility_cart_pass_url(@utility_cart_pass), notice: "Utility Cart Pass was successfully created." }
        format.json { render :show, status: :created, location: @utility_cart_pass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @utility_cart_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /utility_cart_passes/1 or /utility_cart_passes/1.json
  def update
    respond_to do |format|
      if @utility_cart_pass.update(utility_cart_pass_params)
        format.html { redirect_to utility_cart_pass_url(@utility_cart_pass), notice: "Utility Cart Pass was successfully updated." }
        format.json { render :show, status: :ok, location: @utility_cart_pass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @utility_cart_pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /utility_cart_passes/1 or /utility_cart_passes/1.json
  def destroy
    @utility_cart_pass.destroy

    respond_to do |format|
      format.html { redirect_to utility_cart_passes_url, notice: "Utility Cart Pass was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_utility_cart_pass
      @utility_cart_pass = UtilityCartPass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def utility_cart_pass_params
      params.require(:utility_cart_pass).permit(
        :resident_id,
        :description,
        :state_code,
        :sticker_number,
      )
    end
end
