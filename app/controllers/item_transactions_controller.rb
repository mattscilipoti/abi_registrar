class ItemTransactionsController < ApplicationController
  before_action :set_item_transaction, only: %i[ show edit update destroy ]

  # GET /item_transactions or /item_transactions.json
  def index
    default_sort_column = 'transacted_at'
    if params[:sort].blank?
      params[:sort] = { column: default_sort_column, direction: 'desc' }
    end
    @item_transactions = filter_models(ItemTransaction, params[:q])
  end

  # GET /item_transactions/1 or /item_transactions/1.json
  def show
  end

  # GET /item_transactions/new
  def new
    @item_transaction = ItemTransaction.new
  end

  # GET /item_transactions/1/edit
  def edit
  end

  # POST /item_transactions or /item_transactions.json
  def create
    @item_transaction = ItemTransaction.new(item_transaction_params)

    respond_to do |format|
      if @item_transaction.save
        format.html { redirect_to item_transaction_url(@item_transaction), notice: "ItemTransaction was successfully created." }
        format.json { render :show, status: :created, location: @item_transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_transactions/1 or /item_transactions/1.json
  def update
    respond_to do |format|
      if @item_transaction.update(item_transaction_params)
        format.html { redirect_to item_transaction_url(@item_transaction), notice: "ItemTransaction was successfully updated." }
        format.json { render :show, status: :ok, location: @item_transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_transactions/1 or /item_transactions/1.json
  def destroy
    @item_transaction.destroy

    respond_to do |format|
      format.html { redirect_to item_transactions_url, notice: "ItemTransaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_transaction
      @item_transaction = ItemTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_transaction_params
      params.require(:item_transaction).permit(
        :activity,
        :cost_per,
        :cost_total,
        :transacted_at,
        :quantity,
        :residency_id,
        :type,
      )
    end

    def void_item_transaction_params
      params.require(:share_transaction).permit(:reason)
    end
end
