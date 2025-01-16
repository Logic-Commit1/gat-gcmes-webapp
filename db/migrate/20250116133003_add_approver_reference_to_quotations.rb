class AddApproverReferenceToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_reference :quotations, :approver, null: true, foreign_key: { to_table: :users }
  end
end
