require "application_system_test_case"

class PurchaseSharesTest < ApplicationSystemTestCase
  setup do
    @purchase_share = purchase_shares(:one)
  end

  test "visiting the index" do
    visit purchase_shares_url
    assert_selector "h1", text: "Purchase shares"
  end

  test "should create purchase share" do
    visit purchase_shares_url
    click_on "New purchase share"

    click_on "Create Purchase share"

    assert_text "Purchase share was successfully created"
    click_on "Back"
  end

  test "should update Purchase share" do
    visit purchase_share_url(@purchase_share)
    click_on "Edit this purchase share", match: :first

    click_on "Update Purchase share"

    assert_text "Purchase share was successfully updated"
    click_on "Back"
  end

  test "should destroy Purchase share" do
    visit purchase_share_url(@purchase_share)
    click_on "Destroy this purchase share", match: :first

    assert_text "Purchase share was successfully destroyed"
  end
end
