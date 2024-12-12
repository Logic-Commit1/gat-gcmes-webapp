class AddDeletedAtToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :deleted_at, :datetime
    add_index :quotations, :deleted_at
  end
end
