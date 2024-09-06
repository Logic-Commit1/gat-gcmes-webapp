class PurchaseOrder < ApplicationRecord
  belongs_to :company
  belongs_to :supplier
  belongs_to :project, optional: true

  has_many :products
  has_many :particulars
  has_many :request_forms

  enum :terms, [ "50% downpayment", "30 days", "Paid" ]
end
