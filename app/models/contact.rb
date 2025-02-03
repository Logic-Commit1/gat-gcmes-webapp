class Contact < ApplicationRecord
  SALUTATIONS = ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Engr.'].freeze

  belongs_to :contactable, polymorphic: true

  # validates :name, presence: true
  # validates :emails, presence: true
  # validates :contact_numbers, presence: true
end 