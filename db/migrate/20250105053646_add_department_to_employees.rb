class AddDepartmentToEmployees < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :department, :integer, default: 0
  end
end
