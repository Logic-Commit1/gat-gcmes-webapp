class Project < ApplicationRecord
  belongs_to :client
  has_one_attached :client_po

  enum payment: { '50% downpayment' => 0, '30 days' => 1, 'Paid' => 2 }
end
