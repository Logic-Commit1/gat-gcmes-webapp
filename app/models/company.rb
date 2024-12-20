class Company < ApplicationRecord
  has_many :clients
  has_many :suppliers
  has_many :quotations
  has_many :projects
  has_many :request_forms
  has_many :canvasses

  def gat?
    code.downcase == 'gat'
  end

  def gcmes?
    code.downcase == 'gcmes'
  end
end
