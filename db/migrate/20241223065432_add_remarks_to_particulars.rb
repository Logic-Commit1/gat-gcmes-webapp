class AddRemarksToParticulars < ActiveRecord::Migration[7.2]
  def change
    add_column :particulars, :remarks, :text
  end
end
