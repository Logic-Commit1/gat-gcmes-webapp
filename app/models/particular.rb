class Particular < ApplicationRecord
  belongs_to :request_form, optional: true
end
