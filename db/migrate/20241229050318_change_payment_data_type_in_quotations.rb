class ChangePaymentDataTypeInQuotations < ActiveRecord::Migration[7.2]
  def change
    change_column :quotations, :payment, :integer, using: 'payment::integer'
  end
end
