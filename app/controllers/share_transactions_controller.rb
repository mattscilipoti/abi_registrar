class ShareTransactionsController < ApplicationController
  before_action :set_share_transaction, only: %i[ show edit update destroy ]

  # GET /share_transactions or /share_transactions.json
  def index
    @share_transactions = ShareTransaction.all
  end

  # GET /share_transactions/1 or /share_transactions/1.json
  def show
  end

  # GET /share_transactions/new
  def new
    @share_transaction = ShareTransaction.new
  end

  # POST /share_transactions or /share_transactions.json
  def create
    @share_transaction = ShareTransaction.new(share_transaction_params)

    respond_to do |format|
      if @share_transaction.save
        format.html { redirect_to share_transaction_url(@share_transaction), notice: "ItemTransaction share was successfully created." }
        format.json { render :show, status: :created, location: @share_transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @share_transaction.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share_transaction
      @share_transaction = ShareTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def share_transaction_params
      params.require(:share_transaction).permit(:quantity, :item_transactiond_at, :residency_id)
    end
end
