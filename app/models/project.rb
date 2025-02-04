class Project < ApplicationRecord
  belongs_to :client
  belongs_to :company
  belongs_to :user

  has_many :quotations
  has_many :request_forms
  has_many :purchase_orders
  has_many :canvasses
  
  has_one_attached :client_po, dependent: :destroy
  has_many_attached :work_acceptance_files, dependent: :destroy
  has_many_attached :delivery_receipt_files, dependent: :destroy

  enum :payment, [ "50% downpayment", "30 days", "Paid" ]
  enum :status, [ "ongoing", "served", "cancelled" ]

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

  # Callbacks
  before_validation :set_client_from_quotation
  before_save :set_uid
  before_save :clean_technical_team
  after_update :check_sales_invoice

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

  # def required_work_acceptance_count
  #   quotations.where(quotation_type: ['service', 'service_and_supply']).count
  # end

  # def required_delivery_receipt_count
  #   quotations.where(quotation_type: ['supply', 'service_and_supply']).count
  # end

  def requires_work_acceptance?
    quotations.joins(products: :scopes).exists?
  end

  def requires_delivery_receipt?
    quotations.joins(products: :specs).exists?
  end

  # def remaining_work_acceptance_count
  #   required = required_work_acceptance_count
  #   attached = work_acceptance_files.count
  #   [required - attached, 0].max
  # end

  # def remaining_delivery_receipt_count
  #   required = required_delivery_receipt_count
  #   attached = delivery_receipt_files.count
  #   [required - attached, 0].max
  # end

  # def work_acceptance_complete?
  #   remaining_work_acceptance_count == 0
  # end

  # def delivery_receipt_complete?
  #   remaining_delivery_receipt_count == 0
  # end

  # def check_and_update_status
  #   if work_acceptance_complete? && delivery_receipt_complete?
  #     update_column(:status, 'served') unless served?
  #   else
  #     update_column(:status, 'ongoing') unless ongoing?
  #   end
  # end

  private

  def clean_technical_team
    self.technical_team = technical_team.reject(&:blank?) if technical_team.is_a?(Array)
  end

  def set_client_from_quotation
    return if quotations.empty?
    self.client = quotations.first.client
  end

  def check_sales_invoice
    return unless saved_change_to_sales_invoice?

    begin
      if sales_invoice.present?
        # Only update to served if not already served to avoid unnecessary updates
        unless served?
          update_columns(
            status: Project.statuses['served'],
            served_at: Time.current
          )
        end
      else
        # Only update to ongoing if not already ongoing
        unless ongoing?
          update_columns(
            status: :ongoing,
            served_at: nil
          )
        end
      end
    rescue => e
      Rails.logger.error "Error updating project status: #{e.message}"
      # Re-raise the error to ensure it's caught by the application's error handling
      raise
    end
  end
end
