class Product < ApplicationRecord
  belongs_to :quotation
  # belongs_to :canvass
  # belongs_to :purchase_order
  # belongs_to :request_form
end
