class AddApproverAndApprovedAtToCanvasses < ActiveRecord::Migration[7.2]
  def change
    add_column :canvasses, :approver, :string
    add_column :canvasses, :approved_at, :datetime
  end
end

