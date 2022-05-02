require "test_helper"

class ShareTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @share_transaction = share_transactions(:one)
  end

  test "should get index" do
    get share_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_share_transaction_url
    assert_response :success
  end

  test "should create share_transaction" do
    assert_difference("ShareTransaction.count") do
      post share_transactions_url, params: { share_transaction: {  } }
    end

    assert_redirected_to share_transaction_url(ShareTransaction.last)
  end

  test "should show share_transaction" do
    get share_transaction_url(@share_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_share_transaction_url(@share_transaction)
    assert_response :success
  end

  test "should update share_transaction" do
    patch share_transaction_url(@share_transaction), params: { share_transaction: {  } }
    assert_redirected_to share_transaction_url(@share_transaction)
  end

  test "should destroy share_transaction" do
    assert_difference("ShareTransaction.count", -1) do
      delete share_transaction_url(@share_transaction)
    end

    assert_redirected_to share_transactions_url
  end
end
