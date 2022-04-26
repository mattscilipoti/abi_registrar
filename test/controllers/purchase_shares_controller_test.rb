require "test_helper"

class PurchaseSharesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase_share = purchase_shares(:one)
  end

  test "should get index" do
    get purchase_shares_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_share_url
    assert_response :success
  end

  test "should create purchase_share" do
    assert_difference("PurchaseShare.count") do
      post purchase_shares_url, params: { purchase_share: {  } }
    end

    assert_redirected_to purchase_share_url(PurchaseShare.last)
  end

  test "should show purchase_share" do
    get purchase_share_url(@purchase_share)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_share_url(@purchase_share)
    assert_response :success
  end

  test "should update purchase_share" do
    patch purchase_share_url(@purchase_share), params: { purchase_share: {  } }
    assert_redirected_to purchase_share_url(@purchase_share)
  end

  test "should destroy purchase_share" do
    assert_difference("PurchaseShare.count", -1) do
      delete purchase_share_url(@purchase_share)
    end

    assert_redirected_to purchase_shares_url
  end
end
