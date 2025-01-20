class Employee < ApplicationRecord
    has_many :purchase_orders
    has_one :user

    # enum :status, [ :pending, :approved, :rejected ]
    enum :department, [ :operation, :accounting, :purchasing, :sales, :warehouse, :information_technology ]
    validates :position, presence: true
    validates :email, presence: true, uniqueness: true
    validates :department, presence: true

end
