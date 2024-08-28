require "application_system_test_case"

class CanvassesTest < ApplicationSystemTestCase
  setup do
    @canvass = canvasses(:one)
  end

  test "visiting the index" do
    visit canvasses_url
    assert_selector "h1", text: "Canvasses"
  end

  test "should create canvass" do
    visit canvasses_url
    click_on "New canvass"

    fill_in "Company", with: @canvass.company_id
    fill_in "Uid", with: @canvass.uid
    click_on "Create Canvass"

    assert_text "Canvass was successfully created"
    click_on "Back"
  end

  test "should update Canvass" do
    visit canvass_url(@canvass)
    click_on "Edit this canvass", match: :first

    fill_in "Company", with: @canvass.company_id
    fill_in "Uid", with: @canvass.uid
    click_on "Update Canvass"

    assert_text "Canvass was successfully updated"
    click_on "Back"
  end

  test "should destroy Canvass" do
    visit canvass_url(@canvass)
    click_on "Destroy this canvass", match: :first

    assert_text "Canvass was successfully destroyed"
  end
end
