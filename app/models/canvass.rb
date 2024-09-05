class Canvass < ApplicationRecord
  belongs_to :company
  has_many :products, dependent: :destroy, inverse_of: :canvass
  has_many :request_forms

  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  before_save :set_uid
  before_save :set_suppliers

  def set_uid 
    return if self.uid.present?
    company_code = self.company.code
    year_str = Time.now.year.to_s[2, 2]
    count = Canvass.count
    self.uid = "#{company_code}-CAN-#{year_str}-#{(count+1).to_s.rjust(3, '0')}"
  end

  def set_suppliers
    # Create an array to hold the formatted suppliers information
    suppliers_info = []

    # Group the products by their description
    grouped_products = products.group_by(&:description)

    # Iterate over each group
    grouped_products.each do |description, products|
      # Create an array to hold each supplier's data
      suppliers_array = products.map do |product|
        {
          product.supplier.name => [product.price, product.terms, product.remarks]
        }
      end

      # Append the formatted data to the suppliers_info array
      suppliers_info << { description => suppliers_array }
    end

    # Set the suppliers attribute to the formatted suppliers_info array
    self.suppliers = suppliers_info
  end
end
