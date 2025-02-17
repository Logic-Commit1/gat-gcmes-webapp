class CanvassesController < ApplicationController
  include PrawnPdfGenerator
  include Voidable
  
  layout 'pdf', only: :pdf_view

  before_action :set_canvass, only: %i[ show edit update approve pending reject void pdf_view download_pdf print_pdf select_supplier ]
  before_action :check_user_has_signature, only: %i[ new create edit update ]
  before_action :set_resource_for_pdf, only: %i[ download_pdf print_pdf ]
  before_action :ensure_manager, only: [:select_supplier]

  # GET /canvasses or /canvasses.json
  def index
    @canvasses = Canvass.latest_first
                        .search_by_term(params[:query])
                        .created_on_date(params[:date])

    @pagy, @canvasses = pagy(@canvasses)
    
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "canvasses_table", 
          partial: "components/table_body", 
          locals: { documents: @canvasses, title: "Canvasses" }
        )
      end
    end
  end

  # GET /canvasses/1 or /canvasses/1.json
  def show
  end

  def pdf_view
    # pdf_path = @canvass.pdf_path
  
    # if File.exist?(pdf_path)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # else
    #   generate_pdf(@canvass)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # end
  end

  # GET /canvasses/new
  def new
    @canvass = Canvass.new(canvass_params)
    @canvass.products.build
  end

  # GET /canvasses/1/edit
  def edit
  end

  # POST /canvasses or /canvasses.json
  def create
    @canvass = Canvass.new(canvass_params)
    @canvass.user = current_user

    respond_to do |format|
      if @canvass.save
        format.html { redirect_to canvass_url(@canvass), notice: "Canvass was successfully created." }
        format.json { render :show, status: :created, location: @canvass }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @canvass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /canvasses/1 or /canvasses/1.json
  def update
    respond_to do |format|
      if @canvass.update(canvass_params)
        format.html { redirect_to canvass_url(@canvass), notice: "Canvass was successfully updated." }
        format.json { render :show, status: :ok, location: @canvass }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @canvass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canvasses/1 or /canvasses/1.json
  # def destroy
  #   @canvass.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to canvasses_url, notice: "Canvass was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  def void
    @canvass.update(deleted_by: current_user)
    if @canvass.destroy
      flash[:success] = 'Canvass was successfully voided.'
      redirect_to canvasses_path
    else
      flash[:error] = 'Failed to void canvass.'
      redirect_to @canvass
    end
  end

  def approve
    if @canvass.approved!
      @canvass.update(approved_at: Time.now, approver: current_user)
      flash[:success] = "Canvass approved successfully!"
    else
      flash[:error] = "Failed to approve canvass."
    end

    redirect_to @canvass
  end

  def pending
    if @canvass.pending!
      flash[:success] = "Canvass pending successfully!"
    else
      flash[:error] = "Failed to pending canvass."
    end

    redirect_to @canvass
  end

  def reject
    if @canvass.rejected!
      @canvass.update(rejected_at: Time.now, rejector: current_user)
      flash[:success] = "Canvass rejected successfully!"
    else
      flash[:error] = "Failed to reject canvass."
    end

    redirect_to @canvass
  end

  def select_supplier
    selected_supplier = params[:selected_supplier]
    
    # Update the suppliers array to mark the selected supplier
    updated_suppliers = @canvass.suppliers.map do |product_info|
      product_info.map do |description, suppliers|
        suppliers_with_selection = suppliers.map do |supplier_info|
          supplier_info.transform_values do |details|
            details[4] = supplier_info.keys.first == selected_supplier  # Update the last element
            details
          end
        end
        { description => suppliers_with_selection }
      end
    end.flatten

    if @canvass.update(suppliers: updated_suppliers)
      redirect_to pdf_view_canvass_path(@canvass)
    else
      redirect_to pdf_view_canvass_path(@canvass)
    end
  end

  private
    def ensure_manager
      unless current_user.manager?
        redirect_to pdf_view_canvass_path(@canvass), alert: 'Only managers can select suppliers'
      end
    end

    def set_resource_for_pdf
      @resource = @canvass
    end

    def set_canvass
      if current_user.admin? || current_user.developer?
        @canvass = Canvass.with_deleted.find(params[:id])
      else
        @canvass = Canvass.find(params[:id])
      end
    end

    def canvass_params
      params.require(:canvass).permit(:uid, :company_id, :project_id, :description, :quantity, :unit, :suppliers,
      products_attributes: [ :id, :name, :quantity, :unit, :price, :discount, :brand, :description, :specs, :terms, :remarks, :image, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy, :supplier_id, :_destroy ]
      )
    rescue
      {}
    end
end
