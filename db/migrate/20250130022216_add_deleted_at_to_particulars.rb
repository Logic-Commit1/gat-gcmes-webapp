class AddDeletedAtToParticulars < ActiveRecord::Migration[7.2]
  def change
    add_column :particulars, :deleted_at, :datetime
    add_index :particulars, :deleted_at
  end
end
