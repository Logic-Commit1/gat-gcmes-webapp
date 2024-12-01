class RequestForm < ApplicationRecord
  belongs_to :canvass, optional: true
  belongs_to :quotation
  belongs_to :company
  belongs_to :project
  belongs_to :purchase_order, optional: true

  has_many :particulars, dependent: :destroy, inverse_of: :request_form
  accepts_nested_attributes_for :particulars, allow_destroy: true, reject_if: :all_blank

  has_many :products, dependent: :destroy, inverse_of: :request_form
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :request_type, ['Allowance', 'Order']

  before_save :compute_totals_request_form
  before_save :set_sequence_id
  before_save :set_uid

  def compute_totals_request_form
    if products.present?
      products.each { |product| product.compute_total_amount }
    end

    compute_total
  end

  def set_uid 
    return if self.uid.present?
    form_type = self.Allowance? ? "A" : "O"
    self.uid = "RFN-#{form_type}F-#{self.sequence_id.to_s.rjust(6, '0')}"
  end

  private
  def set_sequence_id
    sequence_record = RequestFormSequence.find_or_create_by(request_type: request_type)
    self.sequence_id = sequence_record.last_sequence.to_i + 1
    sequence_record.update(last_sequence: self.sequence_id)
  end
  def compute_total
    if products.present?
      self.total = products.sum { |product| product.total }
    elsif particulars.present?
      self.total = particulars.sum { |product| product.allowance }
    else
      p 'not valid'
    end
  end
end
