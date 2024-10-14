class MainController < ApplicationController
  def index
    @request_forms = RequestForm.all
    @purchase_orders = PurchaseOrder.all
    @quotations = Quotation.all
  end
end
