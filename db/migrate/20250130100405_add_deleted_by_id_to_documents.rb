class AddDeletedByIdToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_reference :canvasses, :deleted_by, foreign_key: { to_table: :users }, null: true
    add_reference :purchase_orders, :deleted_by, foreign_key: { to_table: :users }, null: true
    add_reference :quotations, :deleted_by, foreign_key: { to_table: :users }, null: true
    add_reference :request_forms, :deleted_by, foreign_key: { to_table: :users }, null: true
  end
end
