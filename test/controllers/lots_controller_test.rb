require "test_helper"

class LotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lot = lots(:one)
  end

  test "should get index" do
    get lots_url
    assert_response :success
  end

  test "should get new" do
    get new_lot_url
    assert_response :success
  end

  test "should create lot" do
    assert_difference("Lot.count") do
      post lots_url, params: { lot: { account_number: @lot.account_number, district: @lot.district, lot_number: @lot.lot_number, section: @lot.section, size: @lot.size, subdivision: @lot.subdivision } }
    end

    assert_redirected_to lot_url(Lot.last)
  end

  test "should show lot" do
    get lot_url(@lot)
    assert_response :success
  end

  test "should get edit" do
    get edit_lot_url(@lot)
    assert_response :success
  end

  test "should update lot" do
    patch lot_url(@lot), params: { lot: { account_number: @lot.account_number, district: @lot.district, lot_number: @lot.lot_number, section: @lot.section, size: @lot.size, subdivision: @lot.subdivision } }
    assert_redirected_to lot_url(@lot)
  end

  test "should destroy lot" do
    assert_difference("Lot.count", -1) do
      delete lot_url(@lot)
    end

    assert_redirected_to lots_url
  end
end
