class AddServedAtToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :served_at, :datetime
  end
end
