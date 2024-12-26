class AddPurchaseOrderToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :purchase_order, null: true, foreign_key: true
  end
end
