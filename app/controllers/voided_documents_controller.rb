class VoidedDocumentsController < ApplicationController
  
  def index
    # Collect all voided documents from different models
    voided_quotations = Quotation.only_deleted.latest_first
    voided_canvasses = Canvass.only_deleted.latest_first
    voided_request_forms = RequestForm.only_deleted.latest_first
    voided_purchase_orders = PurchaseOrder.only_deleted.latest_first

    # Combine all voided documents into a single array
    @all_voided_documents = [
      voided_quotations,
      voided_canvasses,
      voided_request_forms,
      voided_purchase_orders
    ].flatten.sort_by(&:deleted_at).reverse

    # Initialize pagy for pagination
    @pagy, @documents = pagy_array(@all_voided_documents, items: 10)

    # Handle search functionality
    if params[:search].present?
      search_term = params[:search].downcase
      @documents = @documents.select do |doc|
        doc.uid.downcase.include?(search_term) ||
        doc.class.name.downcase.include?(search_term)
      end
    end

    # Handle date filter
    if params[:date].present?
      date = Date.parse(params[:date])
      @documents = @documents.select do |doc|
        doc.deleted_at.to_date == date
      end
    end
  end

  private

  def find_with_deleted
    model_class.with_deleted.find(params[:id])
  end

  def model_class
    controller_name.classify.constantize
  end

  def filter_params
    params.permit(:search, :date)
  end
end 