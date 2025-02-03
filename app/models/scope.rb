class Scope < ApplicationRecord
  # acts_as_paranoid

  belongs_to :product
  validates :name, presence: true
end
