require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit products_url
    click_on "New product"

    fill_in "Brand", with: @product.brand
    fill_in "Canvass", with: @product.canvass_id
    fill_in "Description", with: @product.description
    fill_in "Image", with: @product.image
    fill_in "Name", with: @product.name
    fill_in "Price", with: @product.price
    fill_in "Purchase order", with: @product.purchase_order_id
    fill_in "Quantity", with: @product.quantity
    fill_in "Quotation", with: @product.quotation_id
    fill_in "Remarks", with: @product.remarks
    fill_in "Request form", with: @product.request_form_id
    fill_in "Specs", with: @product.specs
    fill_in "Terms", with: @product.terms
    fill_in "Unit", with: @product.unit
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "should update Product" do
    visit product_url(@product)
    click_on "Edit this product", match: :first

    fill_in "Brand", with: @product.brand
    fill_in "Canvass", with: @product.canvass_id
    fill_in "Description", with: @product.description
    fill_in "Image", with: @product.image
    fill_in "Name", with: @product.name
    fill_in "Price", with: @product.price
    fill_in "Purchase order", with: @product.purchase_order_id
    fill_in "Quantity", with: @product.quantity
    fill_in "Quotation", with: @product.quotation_id
    fill_in "Remarks", with: @product.remarks
    fill_in "Request form", with: @product.request_form_id
    fill_in "Specs", with: @product.specs
    fill_in "Terms", with: @product.terms
    fill_in "Unit", with: @product.unit
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "should destroy Product" do
    visit product_url(@product)
    click_on "Destroy this product", match: :first

    assert_text "Product was successfully destroyed"
  end
end
