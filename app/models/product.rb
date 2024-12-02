class Product < ApplicationRecord
  belongs_to :quotation, optional: true
  belongs_to :canvass, optional: true
  belongs_to :supplier, optional: true
  belongs_to :request_form, optional: true
  belongs_to :purchase_order, optional: true

  before_save :compute_total_amount

  UNITS_OF_MEASUREMENT = ['g', 'kg', 'pc', 'unit', 'ltr', 'ml'].freeze

  def compute_total_amount
    self.total = self.price * self.quantity * (1 - self.discount)
  end

end