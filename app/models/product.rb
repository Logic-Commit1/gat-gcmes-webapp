class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :quotation, optional: true
  belongs_to :canvass, optional: true
  belongs_to :supplier, optional: true
  belongs_to :request_form, optional: true
  belongs_to :purchase_order, optional: true

  has_many :specs, dependent: :destroy, inverse_of: :product
  has_many :scopes, dependent: :destroy, inverse_of: :product
  accepts_nested_attributes_for :specs, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :scopes, allow_destroy: true, reject_if: :all_blank

  has_one_attached :image, dependent: :destroy

  before_save :compute_total_amount

  # after_restore :restore_specs

  UNITS_OF_MEASUREMENT = ['g', 'kg', 'pc', 'unit', 'ltr', 'ml'].freeze

  def compute_total_amount
    if price && quantity && discount
      self.total = price * quantity * (1 - discount)
    else
      self.total = 0
    end
  end

  private

  def restore_specs
    specs.with_deleted.each(&:restore)
  end

end