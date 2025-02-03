class ChangeTechnicalTeamToJsonbInProjects < ActiveRecord::Migration[7.2]
  def change
    remove_column :projects, :technical_team
    add_column :projects, :technical_team, :jsonb, default: []
  end
end
