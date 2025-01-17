class AddPositionToEmployeesAndUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :employees, :position, :string
    add_column :users, :position, :string
  end
end
