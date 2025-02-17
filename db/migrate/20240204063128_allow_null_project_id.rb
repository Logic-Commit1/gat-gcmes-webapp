class AllowNullProjectId < ActiveRecord::Migration[7.2]
  def change
    change_column_null :canvasses, :project_id, true
    change_column_null :request_forms, :project_id, true
    change_column_null :purchase_orders, :project_id, true
  end
end 