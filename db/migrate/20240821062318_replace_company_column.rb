class ReplaceCompanyColumn < ActiveRecord::Migration[7.2]
  def change
    remove_column :quotations, :company, :integer
    add_reference :quotations, :company, foreign_key: true

    remove_column :projects, :company, :integer
    add_reference :projects, :company, foreign_key: true
  end
end
