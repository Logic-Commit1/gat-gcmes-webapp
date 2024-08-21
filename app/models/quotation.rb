class Quotation < ApplicationRecord
  belongs_to :client
  # belongs_to :user
  belongs_to :company
  has_many :products, dependent: :destroy, inverse_of: :quotation
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]

  before_create :compute_totals

  def compute_totals
    compute_sub_total
    compute_value_added_tax
    compute_total_amount
  end

  private

  def compute_sub_total
    self.sub_total = products.sum { |product| product.price * product.quantity }
  end

  def compute_value_added_tax
    self.vat = self.sub_total * 0.12
  end
  
  def compute_total_amount
    self.total = self.sub_total + self.vat
  end
end
