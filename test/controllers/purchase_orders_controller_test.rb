require "test_helper"

class PurchaseOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase_order = purchase_orders(:one)
  end

  test "should get index" do
    get purchase_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_order_url
    assert_response :success
  end

  test "should create purchase_order" do
    assert_difference("PurchaseOrder.count") do
      post purchase_orders_url, params: { purchase_order: { approver: @purchase_order.approver, checker: @purchase_order.checker, company_id: @purchase_order.company_id, discount: @purchase_order.discount, pre_approver: @purchase_order.pre_approver, preparer: @purchase_order.preparer, project_id: @purchase_order.project_id, requester: @purchase_order.requester, supplier_id: @purchase_order.supplier_id, terms: @purchase_order.terms, total: @purchase_order.total, uid: @purchase_order.uid } }
    end

    assert_redirected_to purchase_order_url(PurchaseOrder.last)
  end

  test "should show purchase_order" do
    get purchase_order_url(@purchase_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_order_url(@purchase_order)
    assert_response :success
  end

  test "should update purchase_order" do
    patch purchase_order_url(@purchase_order), params: { purchase_order: { approver: @purchase_order.approver, checker: @purchase_order.checker, company_id: @purchase_order.company_id, discount: @purchase_order.discount, pre_approver: @purchase_order.pre_approver, preparer: @purchase_order.preparer, project_id: @purchase_order.project_id, requester: @purchase_order.requester, supplier_id: @purchase_order.supplier_id, terms: @purchase_order.terms, total: @purchase_order.total, uid: @purchase_order.uid } }
    assert_redirected_to purchase_order_url(@purchase_order)
  end

  test "should destroy purchase_order" do
    assert_difference("PurchaseOrder.count", -1) do
      delete purchase_order_url(@purchase_order)
    end

    assert_redirected_to purchase_orders_url
  end
end
