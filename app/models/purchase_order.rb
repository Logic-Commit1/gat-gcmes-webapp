class PurchaseOrder < ApplicationRecord
  # acts_as_paranoid
  
  belongs_to :company
  belongs_to :supplier
  belongs_to :project
  belongs_to :request_form, optional: true
  # belongs_to :employee

  has_many :products, dependent: :destroy, inverse_of: :purchase_order
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank
  # has_many :particulars, through: :request_forms
  

  # belongs_to :project, optional: true
  enum :status, [ :pending, :approved, :rejected ]

  enum :terms, [ "50% downpayment", "30 days", "Paid" ]
  
  before_save :set_uid
  before_save :set_total

  def set_uid
    return if self.uid.present?

    company_code = self.company.code
    supplier_code = self.supplier.code
    count = PurchaseOrder.where(company_id: self.company_id).count
    
    self.uid = "#{company_code}_#{supplier_code}_#{(count+1).to_s.rjust(5, '0')}"
  end

  def set_total
    self.total = self.products.sum { |product| product.price * product.quantity }
  end
end
