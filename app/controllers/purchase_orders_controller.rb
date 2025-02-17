class PurchaseOrdersController < ApplicationController
  include PrawnPdfGenerator
  # include GroverPdfGenerator
  include Voidable
  
  layout 'pdf', only: :pdf_view
  before_action :set_purchase_order, only: %i[ show edit update approve pending reject void pdf_view download_pdf print_pdf ]
  before_action :check_user_has_signature, only: %i[ new create edit update ]
  before_action :set_resource_for_pdf, only: %i[ download_pdf print_pdf ]

  # GET /purchase_orders or /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.latest_first
                                  .search_by_term(params[:query])
                                  .created_on_date(params[:date])

    @pagy, @purchase_orders = pagy(@purchase_orders)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "purchase_orders_table", 
          partial: "components/table_body", 
          locals: { documents: @purchase_orders, title: "Purchase Orders" }
        )
      end
    end
  end

  # GET /purchase_orders/1 or /purchase_orders/1.json
  def show
  end

  def pdf_view
    # pdf_path = @request_form.pdf_path
  
    # if File.exist?(pdf_path)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # else
    #   generate_pdf(@request_form)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # end
  end

  # GET /purchase_orders/new
  def new
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.products.build
  end

  # GET /purchase_orders/1/edit
  def edit
  end

  # POST /purchase_orders or /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.user = current_user

    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to purchase_order_url(@purchase_order), notice: "Purchase order was successfully created." }
        format.json { render :show, status: :created, location: @purchase_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_orders/1 or /purchase_orders/1.json
  def update
    respond_to do |format|
      if @purchase_order.update(purchase_order_params)
        format.html { redirect_to purchase_order_url(@purchase_order), notice: "Purchase order was successfully updated." }
        format.json { render :show, status: :ok, location: @purchase_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1 or /purchase_orders/1.json
  # def destroy
  #   @purchase_order.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to purchase_orders_url, notice: "Purchase order was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  def void
    @purchase_order.update(deleted_by: current_user)
    if @purchase_order.destroy
      flash[:success] = 'Purchase order was successfully voided.'
      redirect_to purchase_orders_path
    else
      flash[:error] = 'Failed to void purchase order.'
      redirect_to @purchase_order
    end
  end

  def approve
    if @purchase_order.approved!
      @purchase_order.update(approved_at: Time.now, approver: current_user)
      flash[:success] = "Purchase order approved successfully!"
    else
      flash[:error] = "Failed to approve purchase order."
    end

    redirect_to @purchase_order
  end

  def pending
    if @purchase_order.pending!
      flash[:success] = "Purchase order pending successfully!"
    else
      flash[:error] = "Failed to pending purchase order."
    end

    redirect_to @purchase_order
  end

  def reject
    if @purchase_order.rejected!
      @purchase_order.update(rejected_at: Time.now, rejector: current_user)
      flash[:success] = "Purchase order rejected successfully!"
    else
      flash[:error] = "Failed to reject purchase order."
    end

    redirect_to @purchase_order
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_purchase_order
    if current_user.admin? || current_user.developer?
      @purchase_order = PurchaseOrder.with_deleted.find(params[:id])
    else
      @purchase_order = PurchaseOrder.find(params[:id])
    end
  end

  
  def set_resource_for_pdf
    @resource = @purchase_order
  end

  # Only allow a list of trusted parameters through.
  def purchase_order_params
    params.require(:purchase_order).permit(:uid, :employee_id, :terms, :total, :discount, :requester, :checker, :pre_approver, :approver, :company_id, :supplier_id, :project_id, :request_form_id,
    products_attributes: [
      :id, :name, :quantity, :unit, :price, :discount, :brand, 
      :description, :specs, :terms, :remarks, :image, 
      :quotation_id, :canvass_id, :request_form_id, :purchase_order_id,
      :_destroy,
      specs_attributes: [:id, :name, :value, :_destroy]
    ]
    )
  rescue
    {}
  end
end
