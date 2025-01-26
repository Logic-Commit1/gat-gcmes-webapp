class Project < ApplicationRecord
  belongs_to :client
  belongs_to :company
  belongs_to :user

  has_many :quotations
  has_many :request_forms
  has_many :purchase_orders
  has_many :canvasses
  
  has_one_attached :client_po, dependent: :destroy

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ "Ongoing", "Served", "Cancelled" ]

  # Scopes
  scope :latest_first, -> { order(created_at: :desc) }

  scope :search_by_term, ->(query) {
    return all unless query.present?
    
    query = query.downcase
    status_matches = statuses.keys.select { |k| k.downcase.include?(query) }
    payment_matches = payments.keys.select { |k| k.downcase.include?(query) }

    joins(:client).where(
      "projects.uid ILIKE :query OR 
       projects.po_number ILIKE :query OR 
       clients.name ILIKE :query OR
       status IN (:status_values) OR
       payment IN (:payment_values)", 
      query: "%#{query}%",
      status_values: status_matches.map { |k| statuses[k] },
      payment_values: payment_matches.map { |k| payments[k] }
    )
  }

  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(projects.created_at) = ?", Date.parse(date))
  }

  before_save :set_uid

  def set_uid 
    return if self.uid.present?

    company_code = self.company.code
    year_str = Time.now.year
    sequence = DocumentSequence.next_sequence('project', company_code)
    self.uid = "#{company_code}_PROJ#{year_str}_#{sequence.to_s.rjust(4, '0')}"
  end
   
  def gat?
    self.company.code.downcase == 'gat'
  end

  def gcmes?
    self.company.code.downcase == 'gcmes'
  end
end
