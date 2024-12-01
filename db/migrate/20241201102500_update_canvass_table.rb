class UpdateCanvassTable < ActiveRecord::Migration[7.2]
  def change
    add_column :canvasses, :description, :string
    add_column :canvasses, :quantity, :integer, default: 0
    add_column :canvasses, :unit, :string
  end
end
