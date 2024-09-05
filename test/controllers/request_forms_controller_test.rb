require "test_helper"

class RequestFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @request_form = request_forms(:one)
  end

  test "should get index" do
    get request_forms_url
    assert_response :success
  end

  test "should get new" do
    get new_request_form_url
    assert_response :success
  end

  test "should create request_form" do
    assert_difference("RequestForm.count") do
      post request_forms_url, params: { request_form: { approver: @request_form.approver, canvass_id: @request_form.canvass_id, checker: @request_form.checker, company_id: @request_form.company_id, destination: @request_form.destination, easy_trip_balance: @request_form.easy_trip_balance, fuel_gauge: @request_form.fuel_gauge, pre_approver: @request_form.pre_approver, procurer: @request_form.procurer, project_id: @request_form.project_id, quotation_id: @request_form.quotation_id, remarks: @request_form.remarks, requester: @request_form.requester, sweep_balance: @request_form.sweep_balance, total: @request_form.total, travel_date: @request_form.travel_date, type: @request_form.type, uid: @request_form.uid, vehicle: @request_form.vehicle } }
    end

    assert_redirected_to request_form_url(RequestForm.last)
  end

  test "should show request_form" do
    get request_form_url(@request_form)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_form_url(@request_form)
    assert_response :success
  end

  test "should update request_form" do
    patch request_form_url(@request_form), params: { request_form: { approver: @request_form.approver, canvass_id: @request_form.canvass_id, checker: @request_form.checker, company_id: @request_form.company_id, destination: @request_form.destination, easy_trip_balance: @request_form.easy_trip_balance, fuel_gauge: @request_form.fuel_gauge, pre_approver: @request_form.pre_approver, procurer: @request_form.procurer, project_id: @request_form.project_id, quotation_id: @request_form.quotation_id, remarks: @request_form.remarks, requester: @request_form.requester, sweep_balance: @request_form.sweep_balance, total: @request_form.total, travel_date: @request_form.travel_date, type: @request_form.type, uid: @request_form.uid, vehicle: @request_form.vehicle } }
    assert_redirected_to request_form_url(@request_form)
  end

  test "should destroy request_form" do
    assert_difference("RequestForm.count", -1) do
      delete request_form_url(@request_form)
    end

    assert_redirected_to request_forms_url
  end
end
