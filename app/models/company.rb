class Company < ApplicationRecord
  has_many :clients
  has_many :suppliers
  has_many :quotations
  has_many :projects
  has_many :request_forms
  has_many :canvasses
  has_many :purchase_orders

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :address, presence: true
  validates :contact_numbers, presence: true
  validates :emails, presence: true

  def contact_numbers_string=(str)
    self.contact_numbers = str.split(',').map(&:strip)
  end

  def contact_numbers_string
    contact_numbers&.join(', ')
  end

  def emails_string=(str)
    self.emails = str.split(',').map(&:strip)
  end

  def emails_string
    emails&.join(', ')
  end

  def gat?
    code.downcase == 'gat'
  end

  def gcmes?
    code.downcase == 'gcmes'
  end
end
