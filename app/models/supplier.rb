class Supplier < ApplicationRecord
  belongs_to :company
  # belongs_to :canvass, optional: true
  # has_many :products
  has_many :products
  has_many :contacts, as: :contactable, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank
  before_validation :process_arrays

  validates :name, presence: true

  scope :latest_first, -> { order(created_at: :desc) }

  private

  def process_arrays
    contacts.each do |contact|
      if contact.emails.is_a?(String)
        contact.emails = contact.emails.split(',').map(&:strip)
      end
    end
  end

end
