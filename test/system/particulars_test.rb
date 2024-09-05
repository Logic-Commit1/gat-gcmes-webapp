require "application_system_test_case"

class ParticularsTest < ApplicationSystemTestCase
  setup do
    @particular = particulars(:one)
  end

  test "visiting the index" do
    visit particulars_url
    assert_selector "h1", text: "Particulars"
  end

  test "should create particular" do
    visit particulars_url
    click_on "New particular"

    fill_in "Allowance", with: @particular.allowance
    fill_in "Name", with: @particular.name
    fill_in "Request form", with: @particular.request_form_id
    click_on "Create Particular"

    assert_text "Particular was successfully created"
    click_on "Back"
  end

  test "should update Particular" do
    visit particular_url(@particular)
    click_on "Edit this particular", match: :first

    fill_in "Allowance", with: @particular.allowance
    fill_in "Name", with: @particular.name
    fill_in "Request form", with: @particular.request_form_id
    click_on "Update Particular"

    assert_text "Particular was successfully updated"
    click_on "Back"
  end

  test "should destroy Particular" do
    visit particular_url(@particular)
    click_on "Destroy this particular", match: :first

    assert_text "Particular was successfully destroyed"
  end
end
