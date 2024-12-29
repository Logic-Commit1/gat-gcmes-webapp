class ChangePoNumberNullInProjects < ActiveRecord::Migration[7.2]
  def up
    # First, update any existing null po_numbers to a default value
    Project.where(po_number: nil).update_all(po_number: 'PENDING')
    
    # Then make the column non-nullable
    change_column_null :projects, :po_number, false
  end

  def down
    change_column_null :projects, :po_number, true
  end
end 