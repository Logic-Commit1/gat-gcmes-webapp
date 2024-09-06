class PurchaseOrder < ApplicationRecord
  belongs_to :company
  belongs_to :supplier
  belongs_to :project

  has_many :products
  has_many :particulars
  has_many :request_forms
end
