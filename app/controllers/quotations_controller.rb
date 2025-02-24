class QuotationsController < ApplicationController
  include Rails.application.routes.url_helpers
  include PrawnPdfGenerator
  include Voidable

  layout 'pdf', only: :pdf_view
  before_action :set_quotation, only: %i[ show edit update void approve pending reject pdf_view download_pdf print_pdf ]
  before_action :check_user_has_signature, only: %i[ show pdf_view new create edit update ]
  before_action :set_resource_for_pdf, only: %i[ download_pdf print_pdf ]

  # GET /quotations or /quotations.json
  def index
    @quotations = Quotation.latest_first
                          .search_by_term(params[:query])
                          .created_on_date(params[:date])

    @pagy, @quotations = pagy(@quotations)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("quotations_table", 
          partial: "components/table_body", 
          locals: { documents: @quotations, title: "Quotations" })
      end
    end
  end

  # GET /quotations/1 or /quotations/1.json
  def show
  end

  def pdf_view
    # pdf_path = @quotation.pdf_path
  
    # if File.exist?(pdf_path)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # else
    #   generate_pdf(@quotation)
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # end
  end

  # GET /quotations/new
  def new
    @quotation = Quotation.new(quotation_params)
    @quotation.products.build
  end

  # GET /quotations/1/edit
  def edit
  end

  # POST /quotations or /quotations.json
   def create
    @quotation = Quotation.new(quotation_params)
    @quotation.user = current_user

    respond_to do |format|
      if @quotation.save
        format.html { redirect_to quotation_url(@quotation), notice: "Quotation was successfully created." }
        format.json { render :show, status: :created, location: @quotation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/1 or /quotations/1.json
  def update
    respond_to do |format|
      if @quotation.update(quotation_params)
        # Check if project association changed
        # project_changed = @quotation.saved_change_to_project_id?
        # old_project_id = @quotation.project_id_before_last_save
        
        # # Update status for both old and new projects if changed
        # if project_changed
        #   Project.find(old_project_id).check_and_update_status if old_project_id
        #   @quotation.project.check_and_update_status if @quotation.project.present?
        # else
        #   # Update current project's status
        #   @quotation.project.check_and_update_status if @quotation.project.present?
        # end

        # @quotation.generate_prawn

        format.html { redirect_to quotation_url(@quotation), notice: "Quotation was successfully updated." }
        format.json { render :show, status: :ok, location: @quotation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1 or /quotations/1.json
  # def destroy
  #   @quotation.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to quotations_url, notice: "Quotation was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  def void
    @quotation.update(deleted_by: current_user)
    if @quotation.destroy
      flash[:success] = 'Quotation was successfully voided.'
      redirect_to quotations_path
    else
      flash[:error] = 'Failed to void quotation.'
      redirect_to @quotation
    end
  end

  def approve
    if @quotation.approved!
      @quotation.update(approved_at: Time.now, approver: current_user)
      flash[:success] = "Quotation approved successfully!"
    else
      flash[:error] = "Failed to approve quotation."
    end

    redirect_to @quotation
  end

  def pending
    pdf_path = @quotation.pdf_path

    if @quotation.pending!
      # generate_pdf(@quotation)
      # send_file pdf_path, type: 'application/pdf', disposition: 'inline'
      flash[:success] = "Quotation pending successfully!"
    else
      flash[:error] = "Failed to pending quotation."
    end

    redirect_to @quotation
  end

  def reject
    if @quotation.rejected!
      @quotation.update(rejected_at: Time.now, rejector: current_user)
      flash[:success] = "Quotation rejected successfully!"
    else
      flash[:error] = "Failed to reject quotation."
    end

    redirect_to @quotation
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      if current_user.admin? || current_user.developer?
        @quotation = Quotation.with_deleted.find(params[:id])
      else
        @quotation = Quotation.find(params[:id])
      end
    end

    def set_resource_for_pdf
      @resource = @quotation
    end

    # Only allow a list of trusted parameters through.
    def quotation_params
      params.require(:quotation).permit(
        :uid, :company_id, :project_id, :client_id, :attention, :vessel, :subject, :user_id,
        :remarks, :payment, :lead_time, :warranty, :sub_total,
        :total, :vat, :additional_conditions, :preparer, :approver, :discount, :discount_rate, :duration,
        
        products_attributes: [
          :id, :name, :quantity, :unit, :price, :discount, :brand, 
          :description, :specs, :terms, :remarks, :image, 
          :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, 
          :_destroy,
          specs_attributes: [:id, :name, :value, :_destroy],
          scopes_attributes: [:id, :name, :_destroy]
        ]
      )
    rescue
      {}
    end
end
