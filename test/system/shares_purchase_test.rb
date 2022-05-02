require "application_system_test_case"

class SharesPurchaseTest < ApplicationSystemTestCase
  setup do
    @share_transaction = share_transactions(:one)
  end

  test "visiting the index" do
    visit share_transactions_url
    assert_selector "h1", text: "Purchase shares"
  end

  test "should create purchase share" do
    visit share_transactions_url
    click_on "New purchase share"

    click_on "Create Purchase share"

    assert_text "Purchase share was successfully created"
    click_on "Back"
  end

  test "should update Purchase share" do
    visit share_transaction_url(@share_transaction)
    click_on "Edit this purchase share", match: :first

    click_on "Update Purchase share"

    assert_text "Purchase share was successfully updated"
    click_on "Back"
  end

  test "should destroy Purchase share" do
    visit share_transaction_url(@share_transaction)
    click_on "Destroy this purchase share", match: :first

    assert_text "Purchase share was successfully destroyed"
  end
end
