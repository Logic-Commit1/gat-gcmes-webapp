class ChangeCanvassAndQuotationNullForRequestForms < ActiveRecord::Migration[7.2]
  def change
    change_column_null :request_forms, :canvass_id, true
    change_column_null :request_forms, :quotation_id, true
  end
end
