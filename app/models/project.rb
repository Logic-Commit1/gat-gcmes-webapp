class Project < ApplicationRecord
  belongs_to :client
  has_one_attached :client_po

  enum payment: ['50% downpayment','30 days', 'Paid']
end
