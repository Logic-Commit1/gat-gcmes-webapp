class AddDurationToQuotations < ActiveRecord::Migration[7.2]
  def change
    add_column :quotations, :duration, :string
  end
end
