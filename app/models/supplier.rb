class Supplier < ApplicationRecord
  belongs_to :company
  # belongs_to :canvass, optional: true
  has_many :products
  has_many :canvasses, through: :products

  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

end
