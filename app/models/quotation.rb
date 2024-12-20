class Quotation < ApplicationRecord
  belongs_to :client
  belongs_to :company
  
  has_many :projects
  has_many :products, dependent: :destroy, inverse_of: :quotation
  has_many :request_forms
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  # validates :company, presence: true
  # validates :client, presence: true
  # validate :must_have_at_least_one_product


  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ :pending, :approved, :rejected ]

  before_save :set_uid
  before_save :compute_totals_quotation

  # Add scopes if necessary
  scope :voided, -> { where.not(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }

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
    count = self.client.quotations.count
    self.uid = "#{client_code}#{year_str}-#{(count+1).to_s.rjust(3, '0')}"
  end

  def pdf_path
    Rails.root.join('tmp/quotations', "#{uid}.pdf")
  end

  def save_pdf(pdf_content)
    FileUtils.mkdir_p(File.dirname(pdf_path))
    File.open(pdf_path, 'wb') { |file| file.write(pdf_content) }
  end

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
end
