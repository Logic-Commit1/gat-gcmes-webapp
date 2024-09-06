class RequestForm < ApplicationRecord
  belongs_to :canvass
  belongs_to :quotation
  belongs_to :company
  belongs_to :project

  has_many :particulars, dependent: :destroy, inverse_of: :request_form
  accepts_nested_attributes_for :particulars, allow_destroy: true, reject_if: :all_blank

  has_many :products, dependent: :destroy, inverse_of: :request_form
  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  enum :request_type, ['Allowance', 'Order']

  before_save :compute_totals_request_form

  def compute_totals_request_form
    if products.present?
      products.each { |product| product.compute_total_amount }
    end

    compute_total
  end

  private

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
