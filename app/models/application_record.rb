class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  UNIT_OF_MEASUREMENTS = %w[pcs cm m km in ft yd mi].freeze
end
