class Particular < ApplicationRecord
  acts_as_paranoid

  belongs_to :request_form, optional: true
  belongs_to :purchase_order, optional: true
end
