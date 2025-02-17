class Canvass < ApplicationRecord
  acts_as_paranoid
  attr_accessor :skip_suppliers_callback

  belongs_to :company
  belongs_to :project, optional: true
  belongs_to :user
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true
  has_many :products, dependent: :destroy, inverse_of: :canvass
  has_many :request_forms
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  # has_one_attached :pdf_report

  enum :status, [ :pending, :approved, :rejected ]

  # Scopes
  scope :latest_first, -> { order(created_at: :desc) }
  scope :voided, -> { where.not(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }
  
  scope :search_by_term, ->(query) {
    return all unless query.present?
    
    query = query.downcase
    status_matches = statuses.keys.select { |k| k.include?(query) }

    where(
      "uid ILIKE :query OR 
       description ILIKE :query OR
       status IN (:status_values)", 
      query: "%#{query}%",
      status_values: status_matches.map { |k| statuses[k] }
    )
  }

  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(created_at) = ?", Date.parse(date))
  }

  before_save :set_uid
  before_save :set_suppliers, if: :should_update_suppliers?
  # before_destroy :delete_pdf

  def set_uid 
    return if self.uid.present?
    company_code = self.company.code
    year_str = Time.now.year.to_s[2, 2]
    sequence = DocumentSequence.next_sequence('canvass', company_code)
    self.uid = "#{company_code}-CAN-#{year_str}-#{sequence.to_s.rjust(3, '0')}"
  end

  def should_update_suppliers?
    return false if skip_suppliers_callback
    new_record? || products.any? { |product| product.changed? } || products.any?(&:marked_for_destruction?)
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
          product.supplier.name => [product.price, product.brand, product.terms, product.remarks, false]
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

  # def generate_prawn 
  #   path = generate_pdf_report
  #   attach_pdf_report(path)
  # end

  # def generate_pdf_report
  #   path = "PdfGenerator::#{self.class}".constantize.new(self).generate
  #   path
  # end

  # def attach_pdf_report(path)
  #   return unless path && File.exist?(path)
  #   self.pdf_report.attach(
  #     io: File.open(path),
  #     filename: "#{self.class.name.underscore}_#{uid}.pdf",
  #     content_type: 'application/pdf'
  #   )

  #   File.delete(path)
  # end

  private

  def delete_pdf
    File.delete(pdf_path) if File.exist?(pdf_path)
  end
end
