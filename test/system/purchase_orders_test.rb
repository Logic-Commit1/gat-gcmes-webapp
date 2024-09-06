require "application_system_test_case"

class PurchaseOrdersTest < ApplicationSystemTestCase
  setup do
    @purchase_order = purchase_orders(:one)
  end

  test "visiting the index" do
    visit purchase_orders_url
    assert_selector "h1", text: "Purchase orders"
  end

  test "should create purchase order" do
    visit purchase_orders_url
    click_on "New purchase order"

    fill_in "Approver", with: @purchase_order.approver
    fill_in "Checker", with: @purchase_order.checker
    fill_in "Company", with: @purchase_order.company_id
    fill_in "Discount", with: @purchase_order.discount
    fill_in "Pre approver", with: @purchase_order.pre_approver
    fill_in "Preparer", with: @purchase_order.preparer
    fill_in "Project", with: @purchase_order.project_id
    fill_in "Requester", with: @purchase_order.requester
    fill_in "Supplier", with: @purchase_order.supplier_id
    fill_in "Terms", with: @purchase_order.terms
    fill_in "Total", with: @purchase_order.total
    fill_in "Uid", with: @purchase_order.uid
    click_on "Create Purchase order"

    assert_text "Purchase order was successfully created"
    click_on "Back"
  end

  test "should update Purchase order" do
    visit purchase_order_url(@purchase_order)
    click_on "Edit this purchase order", match: :first

    fill_in "Approver", with: @purchase_order.approver
    fill_in "Checker", with: @purchase_order.checker
    fill_in "Company", with: @purchase_order.company_id
    fill_in "Discount", with: @purchase_order.discount
    fill_in "Pre approver", with: @purchase_order.pre_approver
    fill_in "Preparer", with: @purchase_order.preparer
    fill_in "Project", with: @purchase_order.project_id
    fill_in "Requester", with: @purchase_order.requester
    fill_in "Supplier", with: @purchase_order.supplier_id
    fill_in "Terms", with: @purchase_order.terms
    fill_in "Total", with: @purchase_order.total
    fill_in "Uid", with: @purchase_order.uid
    click_on "Update Purchase order"

    assert_text "Purchase order was successfully updated"
    click_on "Back"
  end

  test "should destroy Purchase order" do
    visit purchase_order_url(@purchase_order)
    click_on "Destroy this purchase order", match: :first

    assert_text "Purchase order was successfully destroyed"
  end
end
