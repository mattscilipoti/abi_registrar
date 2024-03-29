require "application_system_test_case"

class PropertiesTest < ApplicationSystemTestCase
  setup do
    @property = FactoryBot.build(:property)
  end

  test "visiting the index" do
    visit properties_url
    assert_selector "h1", text: "Properties"
  end

  test "should create property" do
    visit properties_url
    click_on "New property"

    fill_in "Section", with: @lot.section

    fill_in "Street name", with: @property.street_name
    fill_in "Street number", with: @property.street_number
    fill_in "Tax Identifier", with: @lot.tax_identifier
    click_on "Create Property"

    assert_text "Property was successfully created"
    click_on "Back"
  end

  test "should update Property" do
    visit property_url(@property)
    click_on "Edit this property", match: :first

    fill_in "Street name", with: @property.street_name
    fill_in "Street number", with: @property.street_number
    click_on "Update Property"

    assert_text "Property was successfully updated"
    click_on "Back"
  end

  test "should destroy Property" do
    visit property_url(@property)
    click_on "Destroy this property", match: :first

    assert_text "Property was successfully destroyed"
  end
end
