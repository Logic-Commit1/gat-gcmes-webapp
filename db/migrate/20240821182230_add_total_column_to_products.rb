class AddTotalColumnToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :total, :decimal, :default => 0.0
  end
end
