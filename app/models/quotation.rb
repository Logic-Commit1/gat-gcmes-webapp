class Quotation < ApplicationRecord
  include Rails.application.routes.url_helpers
  acts_as_paranoid

  belongs_to :client
  belongs_to :company
  belongs_to :project, optional: true
  belongs_to :user, optional: true
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true
  
  has_many :products, dependent: :destroy, inverse_of: :quotation
  has_many :request_forms
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  # has_one_attached :pdf_report

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ :pending, :approved, :rejected ]
  enum :quotation_type, [ :service, :supply, :service_and_supply ]

  before_save :set_uid
  before_save :compute_totals_quotation

  # after_restore :restore_products

  # Scopes
  scope :latest_first, -> { order(created_at: :desc) }
  scope :voided, -> { where.not(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }

  scope :search_by_term, ->(query) {
    return all unless query.present?
    
    query = query.downcase
    status_matches = statuses.keys.select { |k| k.include?(query) }
    payment_matches = payments.keys.select { |k| k.downcase.include?(query) }

    where(
      "uid ILIKE :query OR 
       subject ILIKE :query OR
       status IN (:status_values) OR
       payment IN (:payment_values)", 
      query: "%#{query}%",
      status_values: status_matches.map { |k| statuses[k] },
      payment_values: payment_matches.map { |k| payments[k] }
    )
  }

  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(created_at) = ?", Date.parse(date))
  }

  def compute_totals_quotation
    products.each { |product| product.compute_total_amount }
    compute_sub_total
    compute_discount_amount
    compute_value_added_tax
    compute_total_amount
  end

  def set_uid 
    return if self.uid.present?
    client_code = self.client.code
    year_str = Time.now.year.to_s[2, 2]
    sequence = DocumentSequence.next_sequence('quotation', client.code)
    self.uid = "#{client_code}#{year_str}-#{sequence.to_s.rjust(3, '0')}"
  end

  def pdf_path
    Rails.root.join('tmp/prawn/quotations', "#{uid}.pdf")
  end

  def save_pdf(pdf_content)
    FileUtils.mkdir_p(File.dirname(pdf_path))
    File.open(pdf_path, 'wb') { |file| file.write(pdf_content) }
  end

  def self.humanized_quotation_types
    quotation_types.keys.map do |type|
      type_parts = type.split('_').map(&:capitalize)
      type_parts[1] = type_parts[1].downcase if type_parts[1] == "And" # Ensure "and" is not capitalized
      type_parts.join(' ')
    end
  end

  # def generate_prawn 
  #   path = generate_pdf_report
  #   attach_pdf_report(path)
  # end

  # def generate_pdf_report
  #   path = "PdfGenerator::#{self.class}".constantize.new(self).generate
  #   Rails.logger.info "📄 PDF generated at: #{path}"
    
  #   unless File.exist?(path)
  #     Rails.logger.error "🚨 ERROR: PDF file was not created!"
  #   end
    
  #   path
  # end

  # def attach_pdf_report(path)
  #   Rails.logger.info "📄 Attaching PDF report from: #{path}"
  
  #   unless path && File.exist?(path)
  #     Rails.logger.error "🚨 ERROR: PDF file does not exist at path: #{path.inspect}"
  #     return
  #   end
  
  #   file_size = File.size(path) rescue 0
  #   Rails.logger.info "📏 File size: #{file_size} bytes"
  
  #   if file_size.zero?
  #     Rails.logger.error "🚨 ERROR: PDF file is empty!"
  #     return
  #   end
  
  #   File.open(path, 'rb') do |file|
  #     self.pdf_report.attach(
  #       io: file,
  #       filename: "#{self.class.name.underscore}_#{uid}.pdf",
  #       content_type: 'application/pdf'
  #     )
  #   end
  
  #   save! # ✅ Ensure record is saved after attaching
  
  #   Rails.logger.info "✅ PDF successfully attached and saved!"
  #   File.delete(path) if File.exist?(path) # Ensure deletion only after attaching
  # end    

  private

  def compute_sub_total
    self.sub_total = products.sum { |product| product.total }
  end

  def compute_discount_amount
    return if self.discount_rate.blank?
    self.discount = self.sub_total * (self.discount_rate / 100)
  end

  def compute_value_added_tax
    self.vat = (self.sub_total - self.discount) * 0.12
  end
  
  def compute_total_amount
    self.total = self.sub_total - self.discount + self.vat 
  end

  def must_have_at_least_one_product
    if products.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "At least one product item must be added")
    end
  end

  def restore_products
    products.with_deleted.each(&:restore)
  end
end
