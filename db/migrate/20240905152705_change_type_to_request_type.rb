class ChangeTypeToRequestType < ActiveRecord::Migration[7.2]
  def change
    rename_column :request_forms, :type, :request_type
  end
end
