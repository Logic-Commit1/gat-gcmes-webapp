class AddDiscountToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :discount, :decimal, default: 0.0
  end
end
