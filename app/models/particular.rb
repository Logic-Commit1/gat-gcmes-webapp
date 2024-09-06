class Particular < ApplicationRecord
  belongs_to :request_form, optional: true
  belongs_to :purchase_order, optional: true
end
