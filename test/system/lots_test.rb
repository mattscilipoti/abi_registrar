require "application_system_test_case"

class LotsTest < ApplicationSystemTestCase
  setup do
    @lot = lots(:one)
  end

  test "visiting the index" do
    visit lots_url
    assert_selector "h1", text: "Lots"
  end

  test "should create lot" do
    visit lots_url
    click_on "New lot"

    fill_in "Account number", with: @lot.account_number
    fill_in "District", with: @lot.district
    fill_in "Lot number", with: @lot.lot_number
    fill_in "Section", with: @lot.section
    fill_in "Size", with: @lot.size
    fill_in "Subdivision", with: @lot.subdivision
    click_on "Create Lot"

    assert_text "Lot was successfully created"
    click_on "Back"
  end

  test "should update Lot" do
    visit lot_url(@lot)
    click_on "Edit this lot", match: :first

    fill_in "Account number", with: @lot.account_number
    fill_in "District", with: @lot.district
    fill_in "Lot number", with: @lot.lot_number
    fill_in "Section", with: @lot.section
    fill_in "Size", with: @lot.size
    fill_in "Subdivision", with: @lot.subdivision
    click_on "Update Lot"

    assert_text "Lot was successfully updated"
    click_on "Back"
  end

  test "should destroy Lot" do
    visit lot_url(@lot)
    click_on "Destroy this lot", match: :first

    assert_text "Lot was successfully destroyed"
  end
end
