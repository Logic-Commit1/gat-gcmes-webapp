class PurchaseOrder < ApplicationRecord
  belongs_to :company
  belongs_to :supplier
  # belongs_to :project, optional: true

  has_many :products, through: :request_forms
  has_many :particulars, through: :request_forms
  has_many :request_forms

  enum :terms, [ "50% downpayment", "30 days", "Paid" ]
end
