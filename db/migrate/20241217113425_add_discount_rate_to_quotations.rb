class AddDiscountRateToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :discount_rate, :decimal, default: 0.0
  end
end
