class RemoveQuotationIdFromProjects < ActiveRecord::Migration[7.2]
  def change
    remove_column :projects, :quotation_id
  end
end
