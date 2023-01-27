require "application_system_test_case"
require 'factory_bot_rails'

class VehiclesTest < ApplicationSystemTestCase
  setup do
    @vehicle_parking_pass = FactoryBot.create(:vehicle_parking_pass)
  end

  test "visiting the index" do
    visit vehicle_parking_passes_url
    assert_selector "h1", text: "Vehicle "
  end

  test "should create vehicle_parking_pass" do
    visit vehicle_parking_passes_url
    click_on "New Vehicle Parking Pass"

    fill_in "Resident", with: @vehicle_parking_pass.resident_id
    fill_in "Sticker number", with: @vehicle_parking_pass.sticker_number
    fill_in "Tag number", with: @vehicle_parking_pass.tag_number
    click_on "Create Vehicle Parking Pass"

    assert_text "Vehicle Parking Pass was successfully created"
    click_on "Back"
  end

  test "should update VehicleParkingPass" do
    visit vehicle_parking_pass_url(@vehicle_parking_pass)
    click_on "Edit this Vehicle Parking Pass", match: :first

    fill_in "Resident", with: @vehicle_parking_pass.resident_id
    fill_in "Sticker number", with: @vehicle_parking_pass.sticker_number
    fill_in "Tag number", with: @vehicle_parking_pass.tag_number
    click_on "Update Vehicle Parking Pass"

    assert_text "Vehicle Parking Pass was successfully updated"
    click_on "Back"
  end

  test "should destroy VehicleParkingPass" do
    visit vehicle_parking_pass_url(@vehicle_parking_pass)
    click_on "Destroy this Vehicle Parking Pass", match: :first

    assert_text "Vehicle Parking Pass was successfully destroyed"
  end
end
