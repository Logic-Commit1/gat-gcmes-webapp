class VoidedDocumentsController < ApplicationController
  include Authorizable
  before_action :authorize_admin!
  
  def index
    # Collect all voided documents from different models
    voided_quotations = Quotation.only_deleted.latest_first
    voided_canvasses = Canvass.only_deleted.latest_first
    voided_request_forms = RequestForm.only_deleted.latest_first
    voided_purchase_orders = PurchaseOrder.only_deleted.latest_first
    # voided_projects = Project.only_deleted.latest_first

    # Combine all voided documents into a single array
    @all_voided_documents = [
      voided_quotations,
      voided_canvasses,
      voided_request_forms,
      voided_purchase_orders,
      # voided_projects
    ].flatten.sort_by(&:deleted_at).reverse

    # Apply filters before pagination
    @filtered_documents = filter_documents(@all_voided_documents)

    # Initialize pagy for pagination with filtered documents
    @pagy, @documents = pagy_array(@filtered_documents, items: 10)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("voided_documents_table", 
          partial: "components/table_body", 
          locals: { documents: @documents, title: "Voided Documents" })
      end
    end
  end

  private

  def filter_documents(documents)
    filtered = documents

    if filter_params[:query].present?
      search_term = filter_params[:query].downcase
      filtered = filtered.select do |doc|
        doc.uid.downcase.include?(search_term) ||
        doc.class.name.downcase.include?(search_term) ||
        doc.deleted_by&.full_name&.downcase.include?(search_term)
      end
    end

    if filter_params[:date].present?
      date = Date.parse(filter_params[:date])
      filtered = filtered.select do |doc|
        doc.deleted_at.to_date == date
      end
    end

    filtered
  end

  def find_with_deleted
    model_class.with_deleted.find(params[:id])
  end

  def model_class
    controller_name.classify.constantize
  end

  def filter_params
    params.permit(:query, :date)
  end
end 