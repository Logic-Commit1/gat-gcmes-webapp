class AddDeletedAtToRequestForms < ActiveRecord::Migration[7.2]
  def change
    add_column :request_forms, :deleted_at, :datetime
    add_index :request_forms, :deleted_at
  end
end
