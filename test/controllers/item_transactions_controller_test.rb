require "test_helper"

class ItemTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get purchases_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_url
    assert_response :success
  end

  test "should create purchase" do
    assert_difference("ItemTransaction.count") do
      post purchases_url, params: { purchase: { cost_per: @purchase.cost_per, cost_total: @purchase.cost_total, quantity: @purchase.quantity, resident_id: @purchase.resident_id, type: @purchase.type } }
    end

    assert_redirected_to purchase_url(ItemTransaction.last)
  end

  test "should show purchase" do
    get purchase_url(@purchase)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_url(@purchase)
    assert_response :success
  end

  test "should update purchase" do
    patch purchase_url(@purchase), params: { purchase: { cost_per: @purchase.cost_per, cost_total: @purchase.cost_total, quantity: @purchase.quantity, resident_id: @purchase.resident_id, type: @purchase.type } }
    assert_redirected_to purchase_url(@purchase)
  end

  test "should destroy purchase" do
    assert_difference("ItemTransaction.count", -1) do
      delete purchase_url(@purchase)
    end

    assert_redirected_to purchases_url
  end
end
