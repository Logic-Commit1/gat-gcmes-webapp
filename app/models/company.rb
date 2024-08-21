class Company < ApplicationRecord
  has_many :clients
  has_many :quotations
  has_many :projects
end
