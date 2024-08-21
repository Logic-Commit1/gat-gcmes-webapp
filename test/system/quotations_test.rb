require "application_system_test_case"

class QuotationsTest < ApplicationSystemTestCase
  setup do
    @quotation = quotations(:one)
  end

  test "visiting the index" do
    visit quotations_url
    assert_selector "h1", text: "Quotations"
  end

  test "should create quotation" do
    visit quotations_url
    click_on "New quotation"

    fill_in "Additional conditions", with: @quotation.additional_conditions
    fill_in "Approver", with: @quotation.approver
    fill_in "Attention", with: @quotation.attention
    fill_in "Client", with: @quotation.client_id
    fill_in "Lead time", with: @quotation.lead_time
    fill_in "Payment", with: @quotation.payment
    fill_in "Preparer", with: @quotation.preparer
    fill_in "Remarks", with: @quotation.remarks
    fill_in "Sub total", with: @quotation.sub_total
    fill_in "Subject", with: @quotation.subject
    fill_in "Total", with: @quotation.total
    fill_in "Uid", with: @quotation.uid
    fill_in "User", with: @quotation.user_id
    fill_in "Vat", with: @quotation.vat
    fill_in "Vessel", with: @quotation.vessel
    fill_in "Warranty", with: @quotation.warranty
    click_on "Create Quotation"

    assert_text "Quotation was successfully created"
    click_on "Back"
  end

  test "should update Quotation" do
    visit quotation_url(@quotation)
    click_on "Edit this quotation", match: :first

    fill_in "Additional conditions", with: @quotation.additional_conditions
    fill_in "Approver", with: @quotation.approver
    fill_in "Attention", with: @quotation.attention
    fill_in "Client", with: @quotation.client_id
    fill_in "Lead time", with: @quotation.lead_time
    fill_in "Payment", with: @quotation.payment
    fill_in "Preparer", with: @quotation.preparer
    fill_in "Remarks", with: @quotation.remarks
    fill_in "Sub total", with: @quotation.sub_total
    fill_in "Subject", with: @quotation.subject
    fill_in "Total", with: @quotation.total
    fill_in "Uid", with: @quotation.uid
    fill_in "User", with: @quotation.user_id
    fill_in "Vat", with: @quotation.vat
    fill_in "Vessel", with: @quotation.vessel
    fill_in "Warranty", with: @quotation.warranty
    click_on "Update Quotation"

    assert_text "Quotation was successfully updated"
    click_on "Back"
  end

  test "should destroy Quotation" do
    visit quotation_url(@quotation)
    click_on "Destroy this quotation", match: :first

    assert_text "Quotation was successfully destroyed"
  end
end
