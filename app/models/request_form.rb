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
end
