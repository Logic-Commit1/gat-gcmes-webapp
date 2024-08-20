class AddCompanyColumnToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :company, :string
  end
end
