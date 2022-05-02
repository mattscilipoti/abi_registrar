require "application_system_test_case"

class ItemTransactionsTest < ApplicationSystemTestCase
  setup do
    @item_transaction = item_transactions(:one)
  end

  test "visiting the index" do
    visit item_transactions_url
    assert_selector "h1", text: "ItemTransactions"
  end

  test "should create item_transaction" do
    visit item_transactions_url
    click_on "New item_transaction"

    fill_in "Cost per", with: @item_transaction.cost_per
    fill_in "Cost total", with: @item_transaction.cost_total
    fill_in "Quantity", with: @item_transaction.quantity
    fill_in "Resident", with: @item_transaction.resident_id
    fill_in "Type", with: @item_transaction.type
    click_on "Create ItemTransaction"

    assert_text "ItemTransaction was successfully created"
    click_on "Back"
  end

  test "should update ItemTransaction" do
    visit item_transaction_url(@item_transaction)
    click_on "Edit this item_transaction", match: :first

    fill_in "Cost per", with: @item_transaction.cost_per
    fill_in "Cost total", with: @item_transaction.cost_total
    fill_in "Quantity", with: @item_transaction.quantity
    fill_in "Resident", with: @item_transaction.resident_id
    fill_in "Type", with: @item_transaction.type
    click_on "Update ItemTransaction"

    assert_text "ItemTransaction was successfully updated"
    click_on "Back"
  end

  test "should destroy ItemTransaction" do
    visit item_transaction_url(@item_transaction)
    click_on "Destroy this item_transaction", match: :first

    assert_text "ItemTransaction was successfully destroyed"
  end
end
