class ShareTransactionsController < ApplicationController
  before_action :set_share_transaction, only: %i[ show edit update destroy ]

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

  # GET /share_transactions/new
  def new
    @share_transaction = ShareTransaction.new
  end

  # GET /share_transactions or /share_transactions.json
  def index
    @share_transactions = ShareTransaction.includes(residency: [:resident, :property]).includes(:from_residency).all.order(transacted_at: :desc)
  end

  # POST //share_transactions/purchase or //share_transactions/purchase.json
  def purchase
    @share_transaction = ShareTransaction.new(purchase_shares_params)

    respond_to do |format|
      if @share_transaction.save
        format.html { redirect_to share_transaction_path(@share_transaction), notice: "Shares were successfully purchased." }
        format.json { render :show, status: :created, location: @share_transaction }
      else
        format.html { render :purchase_new, status: :unprocessable_entity }
        format.json { render json: @share_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def purchase_new
    @share_transaction = ShareTransaction.new(activity: :purchase)
  end
  
  # GET /share_transactions/1 or /share_transactions/1.json
  def show
  end

  # POST //share_transactions/transfer or //share_transactions/transfer.json
  def transfer
    @share_transaction = ShareTransaction.new(transfer_shares_params)

    respond_to do |format|
      if @share_transaction.save
        format.html { redirect_to share_transaction_path(@share_transaction), notice: "Shares were successfully transferred." }
        format.json { render :show, status: :created, location: @share_transaction }
      else
        format.html { render :transfer_new, status: :unprocessable_entity }
        format.json { render json: @share_transaction.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def transfer_new
    @share_transaction = ShareTransaction.new(activity: :transfer)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share_transaction
      @share_transaction = ShareTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_shares_params
      params.require(:share_transaction).permit(
        :residency_id,
        :quantity, 
        :transacted_at, 
        :activity,
      )
    end

    def transfer_shares_params
      params.require(:share_transaction).permit(
        :from_residency_id,
        :residency_id,
        :quantity, 
        :transacted_at, 
        :activity,
      )
    end
end
