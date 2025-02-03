class AddTechnicalTeamToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :technical_team, :string
  end
end
