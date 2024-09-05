class ChangeTypeColumnInRequestForms < ActiveRecord::Migration[7.2]
  def change
    change_column :request_forms, :type, :integer, using: 'CAST(type AS integer)'
  end
end
