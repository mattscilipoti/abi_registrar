require "application_system_test_case"

class ResidentsTest < ApplicationSystemTestCase
  setup do
    @resident = residents(:one)
  end

  test "visiting the index" do
    visit residents_url
    assert_selector "h1", text: "Residents"
  end

  test "should create resident" do
    visit residents_url
    click_on "New resident"

    fill_in "Email address", with: @resident.email_address
    fill_in "First name", with: @resident.first_name
    check "Is minor" if @resident.is_minor
    fill_in "Last name", with: @resident.last_name
    # fill_in "Verified at", with: @resident.verified_at
    click_on "Create Resident"

    assert_text "Resident was successfully created"
    click_on "Back"
  end

  test "should update Resident" do
    visit resident_url(@resident)
    click_on "Edit this resident", match: :first

    fill_in "Email address", with: @resident.email_address
    fill_in "First name", with: @resident.first_name
    check "Is minor" if @resident.is_minor
    fill_in "Last name", with: @resident.last_name
    # fill_in "Verified at", with: @resident.verified_at
    click_on "Update Resident"

    assert_text "Resident was successfully updated"
    click_on "Back"
  end

  test "should destroy Resident" do
    visit resident_url(@resident)
    click_on "Destroy this resident", match: :first

    assert_text "Resident was successfully destroyed"
  end
end
