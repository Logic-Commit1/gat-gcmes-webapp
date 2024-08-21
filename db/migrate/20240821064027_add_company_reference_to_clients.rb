class AddCompanyReferenceToClients < ActiveRecord::Migration[7.2]
  def change
    add_reference :clients, :company, foreign_key: true
  end
end
