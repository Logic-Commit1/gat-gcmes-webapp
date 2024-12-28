class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true

  validates :name, presence: true
  validates :emails, presence: true
  validates :contact_numbers, presence: true
end 