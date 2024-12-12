class AddDeletedAtToCanvasses < ActiveRecord::Migration[7.2]
  def change
    add_column :canvasses, :deleted_at, :datetime
    add_index :canvasses, :deleted_at
  end
end
