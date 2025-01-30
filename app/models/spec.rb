class Spec < ApplicationRecord
  acts_as_paranoid

  belongs_to :product
  validates :name, :value, presence: true
end

