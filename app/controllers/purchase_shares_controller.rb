class PurchaseSharesController < ApplicationController
  before_action :set_purchase_share, only: %i[ show edit update destroy ]

  # GET /purchase_shares or /purchase_shares.json
  def index
    @purchase_shares = PurchaseShare.all
  end

  # GET /purchase_shares/1 or /purchase_shares/1.json
  def show
  end

  # GET /purchase_shares/new
  def new
    @purchase_share = PurchaseShare.new
  end

  # POST /purchase_shares or /purchase_shares.json
  def create
    @purchase_share = PurchaseShare.new(purchase_share_params)

    respond_to do |format|
      if @purchase_share.save
        format.html { redirect_to purchase_share_url(@purchase_share), notice: "Purchase share was successfully created." }
        format.json { render :show, status: :created, location: @purchase_share }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase_share.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_share
      @purchase_share = PurchaseShare.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_share_params
      params.require(:purchase_share).permit(:quantity, :purchased_at, :residency_id)
    end
end
