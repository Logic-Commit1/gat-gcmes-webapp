class AddReferencesToPurchaseOrder < ActiveRecord::Migration[7.2]
  def change
    add_reference :purchase_orders, :products, foreign_key: true
    add_reference :purchase_orders, :particulars, foreign_key: true
    add_reference :purchase_orders, :request_forms, null: false, foreign_key: true
  end
end
