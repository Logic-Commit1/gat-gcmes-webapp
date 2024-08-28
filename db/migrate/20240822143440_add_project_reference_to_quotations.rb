class AddProjectReferenceToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_reference :quotations, :project, null: true, foreign_key: true
  end
end
