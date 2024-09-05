require "application_system_test_case"

class RequestFormsTest < ApplicationSystemTestCase
  setup do
    @request_form = request_forms(:one)
  end

  test "visiting the index" do
    visit request_forms_url
    assert_selector "h1", text: "Request forms"
  end

  test "should create request form" do
    visit request_forms_url
    click_on "New request form"

    fill_in "Approver", with: @request_form.approver
    fill_in "Canvass", with: @request_form.canvass_id
    fill_in "Checker", with: @request_form.checker
    fill_in "Company", with: @request_form.company_id
    fill_in "Destination", with: @request_form.destination
    fill_in "Easy trip balance", with: @request_form.easy_trip_balance
    fill_in "Fuel gauge", with: @request_form.fuel_gauge
    fill_in "Pre approver", with: @request_form.pre_approver
    fill_in "Procurer", with: @request_form.procurer
    fill_in "Project", with: @request_form.project_id
    fill_in "Quotation", with: @request_form.quotation_id
    fill_in "Remarks", with: @request_form.remarks
    fill_in "Requester", with: @request_form.requester
    fill_in "Sweep balance", with: @request_form.sweep_balance
    fill_in "Total", with: @request_form.total
    fill_in "Travel date", with: @request_form.travel_date
    fill_in "Type", with: @request_form.type
    fill_in "Uid", with: @request_form.uid
    fill_in "Vehicle", with: @request_form.vehicle
    click_on "Create Request form"

    assert_text "Request form was successfully created"
    click_on "Back"
  end

  test "should update Request form" do
    visit request_form_url(@request_form)
    click_on "Edit this request form", match: :first

    fill_in "Approver", with: @request_form.approver
    fill_in "Canvass", with: @request_form.canvass_id
    fill_in "Checker", with: @request_form.checker
    fill_in "Company", with: @request_form.company_id
    fill_in "Destination", with: @request_form.destination
    fill_in "Easy trip balance", with: @request_form.easy_trip_balance
    fill_in "Fuel gauge", with: @request_form.fuel_gauge
    fill_in "Pre approver", with: @request_form.pre_approver
    fill_in "Procurer", with: @request_form.procurer
    fill_in "Project", with: @request_form.project_id
    fill_in "Quotation", with: @request_form.quotation_id
    fill_in "Remarks", with: @request_form.remarks
    fill_in "Requester", with: @request_form.requester
    fill_in "Sweep balance", with: @request_form.sweep_balance
    fill_in "Total", with: @request_form.total
    fill_in "Travel date", with: @request_form.travel_date
    fill_in "Type", with: @request_form.type
    fill_in "Uid", with: @request_form.uid
    fill_in "Vehicle", with: @request_form.vehicle
    click_on "Update Request form"

    assert_text "Request form was successfully updated"
    click_on "Back"
  end

  test "should destroy Request form" do
    visit request_form_url(@request_form)
    click_on "Destroy this request form", match: :first

    assert_text "Request form was successfully destroyed"
  end
end
