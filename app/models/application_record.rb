class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  UNIT_OF_MEASUREMENTS = %w[pcs cm m km in ft yd mi].freeze

  def gat?
    self.company.code.downcase == "gat"
  end

  def gcmes?
    self.company.code.downcase == "gcmes"
  end
end
