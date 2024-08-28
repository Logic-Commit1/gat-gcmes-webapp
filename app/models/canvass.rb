class Canvass < ApplicationRecord
  belongs_to :company
  has_many :suppliers
  has_many :products, dependent: :destroy, inverse_of: :canvass

  accepts_nested_attributes_for :products, allow_destroy: true, reject_if: :all_blank

  before_save :set_uid
  before_save :set_suppliers

  def set_uid 
    return if self.uid.present?
    company_code = self.company.code
    year_str = Time.now.year.to_s[2, 2]
    count = Canvass.count
    self.uid = "#{company_code}-CAN-#{year_str}-#{(count+1).to_s.rjust(3, '0')}"
  end

  def set_suppliers
    self.suppliers = self.products.map(&:supplier).uniq.compact
  end
end
