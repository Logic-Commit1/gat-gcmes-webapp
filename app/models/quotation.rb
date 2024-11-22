class Quotation < ApplicationRecord
  belongs_to :client
  belongs_to :company
  belongs_to :project, optional: true
  
  has_many :products, dependent: :destroy, inverse_of: :quotation
  has_many :request_forms
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]

  before_save :set_uid
  before_save :compute_totals_quotation

  def compute_totals_quotation
    products.each { |product| product.compute_total_amount }
    compute_sub_total
    compute_value_added_tax
    compute_total_amount
  end

  def set_uid 
    return if self.uid.present?
    client_code = self.client.code
    year_str = Time.now.year.to_s[2, 2]
    binding.pry
    count = self.client.quotations.count
    self.uid = "#{client_code}#{year_str}-#{(count+1).to_s.rjust(3, '0')}"
  end

  private

  def compute_sub_total
    self.sub_total = products.sum { |product| product.total }
  end

  def compute_value_added_tax
    self.vat = self.sub_total * 0.12
  end
  
  def compute_total_amount
    self.total = self.sub_total + self.vat
  end
end