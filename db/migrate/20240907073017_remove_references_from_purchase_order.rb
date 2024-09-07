class RemoveReferencesFromPurchaseOrder < ActiveRecord::Migration[7.2]
  def change
    remove_reference :purchase_orders, :products, foreign_key: true
    remove_reference :purchase_orders, :particulars, foreign_key: true
    remove_reference :purchase_orders, :request_forms, foreign_key: true
  end
end
