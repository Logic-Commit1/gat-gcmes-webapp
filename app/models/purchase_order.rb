class PurchaseOrder < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :company
  belongs_to :supplier
  belongs_to :project, optional: true
  belongs_to :request_form, optional: true
  belongs_to :user
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :rejector, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true
  # belongs_to :employee

  has_many :products, dependent: :destroy, inverse_of: :purchase_order
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank
  # has_many :particulars, through: :request_forms
  

  # belongs_to :project, optional: true
  enum :status, [ :pending, :approved, :rejected ]

  enum :terms, [ "50% downpayment", "30 days", "Paid" ]
  
  # Scopes for filtering
  scope :search_by_term, ->(query) {
    return all unless query.present?
    
    query = query.downcase
    status_matches = statuses.keys.select { |k| k.include?(query) }
    terms_matches = terms.keys.select { |k| k.downcase.include?(query) }
    joins(:supplier, :products, :company).where(
      "purchase_orders.uid ILIKE :query OR 
       suppliers.name ILIKE :query OR
       products.name ILIKE :query OR
       companies.code ILIKE :query OR
       purchase_orders.status IN (:status_values) OR
       purchase_orders.terms IN (:terms_values)", 
      query: "%#{query}%",
      status_values: status_matches.map { |k| statuses[k] },
      terms_values: terms_matches.map { |k| terms[k] }
    ).distinct
  }
  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(purchase_orders.created_at) = ?", Date.parse(date))
  }
  scope :latest_first, -> { order(created_at: :desc) }
  scope :voided, -> { where.not(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }
  
  before_save :set_uid
  before_save :set_total

  def pdf_path
    Rails.root.join('tmp/purchase_orders', "#{uid}.pdf")
  end

  def save_pdf(pdf_content)
    FileUtils.mkdir_p(File.dirname(pdf_path))
    File.open(pdf_path, 'wb') { |file| file.write(pdf_content) }
  end

  def set_uid
    return if self.uid.present?

    sequence = DocumentSequence.next_sequence('purchase_order', supplier.code)
    self.uid = "PO-#{supplier.code}-#{sequence.to_s.rjust(4, '0')}"
  end

  def set_total
    self.total = self.products.sum { |product| product.price * product.quantity }
  end
end
