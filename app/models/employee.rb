class Employee < ApplicationRecord
    has_many :purchase_orders
end
