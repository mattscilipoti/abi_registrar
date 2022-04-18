class LotsController < ApplicationController
  before_action :set_lot, only: %i[ show edit update destroy ]

  # GET /lots or /lots.json
  def index
    @lots = Lot.all
  end

  # GET /lots/1 or /lots/1.json
  def show
  end

  # GET /lots/new
  def new
    @lot = Lot.new
  end

  # GET /lots/1/edit
  def edit
  end

  # POST /lots or /lots.json
  def create
    @lot = Lot.new(lot_params)

    respond_to do |format|
      if @lot.save
        format.html { redirect_to lot_url(@lot), notice: "Lot was successfully created." }
        format.json { render :show, status: :created, location: @lot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lots/1 or /lots/1.json
  def update
    respond_to do |format|
      if @lot.update(lot_params)
        format.html { redirect_to lot_url(@lot), notice: "Lot was successfully updated." }
        format.json { render :show, status: :ok, location: @lot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lots/1 or /lots/1.json
  def destroy
    @lot.destroy

    respond_to do |format|
      format.html { redirect_to lots_url, notice: "Lot was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lot
      @lot = Lot.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lot_params
      params.require(:lot).permit(:district, :subdivision, :account_number, :lot_number, :section, :size)
    end
end
