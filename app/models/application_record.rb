class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  UNIT_OF_MEASUREMENTS = %w[pcs cm m km in ft yd mi].freeze

  def self.latest_first
    order(created_at: :desc)
  end

  def gat?
    self.company.code.downcase == "gat"
  end

  def gcmes?
    self.company.code.downcase == "gcmes"
  end

  def created_by
    "#{user&.first_name&.titleize} #{user&.last_name&.titleize}"
  end

  def user_signature
    user&.signature&.attached? ? user.signature.variant(resize_to_limit: [300, 100]) : nil
  end

  def check_user_has_signature
    current_user&.signature&.attached?
  end
end
