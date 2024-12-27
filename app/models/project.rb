class Project < ApplicationRecord
  belongs_to :client
  belongs_to :company

  # belongs_to :quotation
  has_many :request_forms
  has_many :purchase_orders
  
  has_one_attached :client_po

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ "Ongoing", "Served" ]

  before_save :set_uid

  def set_uid 
    return if self.uid.present?

    company_code = self.company.code

    year_str = Time.now.year
    count = self.client.quotations.count
    self.uid = "#{company_code}_PROJ#{year_str}_#{(count+1).to_s.rjust(4, '0')}"
  end
end
