class AddSupervisorToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :supervisor, :string
  end
end
