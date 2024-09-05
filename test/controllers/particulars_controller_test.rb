require "test_helper"

class ParticularsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @particular = particulars(:one)
  end

  test "should get index" do
    get particulars_url
    assert_response :success
  end

  test "should get new" do
    get new_particular_url
    assert_response :success
  end

  test "should create particular" do
    assert_difference("Particular.count") do
      post particulars_url, params: { particular: { allowance: @particular.allowance, name: @particular.name, request_form_id: @particular.request_form_id } }
    end

    assert_redirected_to particular_url(Particular.last)
  end

  test "should show particular" do
    get particular_url(@particular)
    assert_response :success
  end

  test "should get edit" do
    get edit_particular_url(@particular)
    assert_response :success
  end

  test "should update particular" do
    patch particular_url(@particular), params: { particular: { allowance: @particular.allowance, name: @particular.name, request_form_id: @particular.request_form_id } }
    assert_redirected_to particular_url(@particular)
  end

  test "should destroy particular" do
    assert_difference("Particular.count", -1) do
      delete particular_url(@particular)
    end

    assert_redirected_to particulars_url
  end
end
