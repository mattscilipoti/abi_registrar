class LotsController < ApplicationController
  before_action :set_lot, only: %i[ show edit update destroy ]

  # GET /lots or /lots.json
  def index
    lots = filter_models(Lot, params[:q])
    @lots = lots.includes(:property).decorate
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
      params[:lot].delete('lot_fee_paid') # support toggleable_lot_fee_paid?

      if @lot.update(lot_params)
        default_destination = lot_url(@lot)
        # if update is from index or show, return to referrer
        destination_path = (request.referrer.present? && !request.referrer.ends_with?('edit')) ? request.referrer : default_destination

        format.html { redirect_to destination_path, notice: "Lot was successfully updated." }
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
      params.require(:lot).permit(
        :lot_number,
        :paid_on,
        :size)
    end
end
