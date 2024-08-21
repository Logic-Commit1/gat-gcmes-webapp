class Quotation < ApplicationRecord
  belongs_to :client
  # belongs_to :user
  has_many :products, dependent: :destroy, inverse_of: :quotation
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :company, { GAT: 0, GCMES: 1 }
end
