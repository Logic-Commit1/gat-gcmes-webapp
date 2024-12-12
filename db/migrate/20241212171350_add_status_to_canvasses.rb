class AddStatusToCanvasses < ActiveRecord::Migration[7.2]
  def change
    add_column :canvasses, :status, :integer, default: 0
  end
end
