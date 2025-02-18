class AddDeleteColumnsToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at

    add_reference :projects, :deleted_by, foreign_key: { to_table: :users }
  end
end
