class AddPoNumberToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :po_number, :string
  end
end
