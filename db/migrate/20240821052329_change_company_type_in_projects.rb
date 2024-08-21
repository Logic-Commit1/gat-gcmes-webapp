class ChangeCompanyTypeInProjects < ActiveRecord::Migration[7.2]
  def change
    change_column :projects, :company, 'integer USING CAST(company AS integer)'
  end
end
