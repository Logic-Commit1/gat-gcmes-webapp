class AddDeletedAtToSpecs < ActiveRecord::Migration[7.2]
  def change
    add_column :specs, :deleted_at, :datetime
    add_index :specs, :deleted_at
  end
end

