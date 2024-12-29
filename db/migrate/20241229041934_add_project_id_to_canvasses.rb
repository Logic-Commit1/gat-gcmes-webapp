class AddProjectIdToCanvasses < ActiveRecord::Migration[7.2]
  def change
    add_reference :canvasses, :project, null: false, foreign_key: true
  end
end
