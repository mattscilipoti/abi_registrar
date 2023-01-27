require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle_parking_pass = vehicle_parking_passes(:one)
  end

  test "should get index" do
    get vehicle_parking_passes_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_parking_pass_url
    assert_response :success
  end

  test "should create vehicle_parking_pass" do
    assert_difference("VehicleParkingPass.count") do
      post vehicle_parking_passes_url, params: { vehicle_parking_pass: { resident_id: @vehicle_parking_pass.resident_id, sticker_number: @vehicle_parking_pass.sticker_number, tag_number: @vehicle_parking_pass.tag_number } }
    end

    assert_redirected_to vehicle_parking_pass_url(VehicleParkingPass.last)
  end

  test "should show vehicle_parking_pass" do
    get vehicle_parking_pass_url(@vehicle_parking_pass)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_parking_pass_url(@vehicle_parking_pass)
    assert_response :success
  end

  test "should update vehicle_parking_pass" do
    patch vehicle_parking_pass_url(@vehicle_parking_pass), params: { vehicle_parking_pass: { resident_id: @vehicle_parking_pass.resident_id, sticker_number: @vehicle_parking_pass.sticker_number, tag_number: @vehicle_parking_pass.tag_number } }
    assert_redirected_to vehicle_parking_pass_url(@vehicle_parking_pass)
  end

  test "should destroy vehicle_parking_pass" do
    assert_difference("VehicleParkingPass.count", -1) do
      delete vehicle_parking_pass_url(@vehicle_parking_pass)
    end

    assert_redirected_to vehicle_parking_passes_url
  end
end
