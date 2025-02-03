class AddDeletedAtToScopes < ActiveRecord::Migration[7.2]
  def change
    add_column :scopes, :deleted_at, :datetime
    add_index :scopes, :deleted_at
  end
end
