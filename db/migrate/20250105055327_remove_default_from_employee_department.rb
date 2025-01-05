class RemoveDefaultFromEmployeeDepartment < ActiveRecord::Migration[7.2]
  def change
    change_column_default :employees, :department, from: 0, to: nil
  end
end
