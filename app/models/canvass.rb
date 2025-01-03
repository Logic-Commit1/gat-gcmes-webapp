class Canvass < ApplicationRecord
  # acts_as_paranoid

  belongs_to :company
  belongs_to :project
  has_many :products, dependent: :destroy, inverse_of: :canvass
  has_many :request_forms
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :status, [ :pending, :approved, :rejected ]

  # Scopes for filtering
  scope :search_by_term, ->(term) { 
    where("uid ILIKE :term OR description ILIKE :term", term: "%#{term}%") 
  }
  scope :created_on_date, ->(date) { 
    where("DATE(created_at) = ?", date) 
  }
  scope :latest_first, -> { order(created_at: :desc) }

  before_save :set_uid
  before_save :set_suppliers
  before_destroy :delete_pdf

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
          product.supplier.name => [product.price, product.brand, product.terms, product.remarks]
        }
      end

      # Append the formatted data to the suppliers_info array
      suppliers_info << { description => suppliers_array }
    end

    # Set the suppliers attribute to the formatted suppliers_info array
    self.suppliers = suppliers_info
  end

  def pdf_path
    Rails.root.join('tmp/canvasses', "#{uid}.pdf")
  end

  def save_pdf(pdf_content)
    FileUtils.mkdir_p(File.dirname(pdf_path))
    File.open(pdf_path, 'wb') { |file| file.write(pdf_content) }
  end

  private

  def delete_pdf
    File.delete(pdf_path) if File.exist?(pdf_path)
  end
end
