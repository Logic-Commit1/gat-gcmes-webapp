class Client < ApplicationRecord
    belongs_to :company
    has_many :quotations
end
