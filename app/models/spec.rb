class Spec < ApplicationRecord
  belongs_to :product
  validates :name, :value, presence: true
end
