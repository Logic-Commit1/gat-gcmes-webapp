class AddRejectorReferenceToTables < ActiveRecord::Migration[7.2]
  def change
    # Add rejector reference to canvasses
    add_reference :canvasses, :rejector, foreign_key: { to_table: :users }, null: true
    
    # Add rejector reference to quotations
    add_reference :quotations, :rejector, foreign_key: { to_table: :users }, null: true
    
    # Add rejector reference to request_forms
    add_reference :request_forms, :rejector, foreign_key: { to_table: :users }, null: true
    
    # Add rejector reference to purchase_orders
    add_reference :purchase_orders, :rejector, foreign_key: { to_table: :users }, null: true
  end
end
