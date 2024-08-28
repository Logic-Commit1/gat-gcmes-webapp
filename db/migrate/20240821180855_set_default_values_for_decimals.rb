class SetDefaultValuesForDecimals < ActiveRecord::Migration[7.2]
  def change
    change_column_default :products, :price, from: nil, to: 0.0
    change_column_default :products, :discount, from: nil, to: 0.0
    change_column_default :projects, :amount, from: nil, to: 0.0
    change_column_default :quotations, :sub_total, from: nil, to: 0.0
    change_column_default :quotations, :total, from: nil, to: 0.0
    change_column_default :quotations, :vat, from: nil, to: 0.0
  end
end
