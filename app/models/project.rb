class Project < ApplicationRecord
  belongs_to :client
  belongs_to :company

  has_many :quotations
  has_many :request_forms
  has_many :purchase_orders
  has_many :canvasses
  
  has_one_attached :client_po

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ "Ongoing", "Served", "Cancelled" ]

  # Scopes for filtering
  scope :search_by_term, ->(term) { 
    joins(:client).where(
      "projects.uid ILIKE :term OR projects.po_number ILIKE :term OR clients.name ILIKE :term", 
      term: "%#{term}%"
    ) 
  }
  scope :created_on_date, ->(date) { 
    where("DATE(projects.created_at) = ?", date) 
  }
  scope :latest_first, -> { order(created_at: :desc) }

  before_save :set_uid

  def set_uid 
    return if self.uid.present?

    company_code = self.company.code

    year_str = Time.now.year
    count = self.client.quotations.count
    self.uid = "#{company_code}_PROJ#{year_str}_#{(count+1).to_s.rjust(4, '0')}"
  end
   
  def gat?
    self.company.code.downcase == 'gat'
  end

  def gcmes?
    self.company.code.downcase == 'gcmes'
  end
end
