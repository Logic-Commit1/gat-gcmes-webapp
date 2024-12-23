class QuotationsController < ApplicationController
  include Rails.application.routes.url_helpers

  layout 'pdf', only: :pdf_view
  before_action :set_quotation, only: %i[ show edit update void approve pending reject pdf_view ]

  # GET /quotations or /quotations.json
  def index
    @quotations = Quotation.order(created_at: :desc)
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
    # @quotation.products.each do |product|
    #   product.specs.build
    # end
  end

  # GET /quotations/1/edit
  def edit
  end

  # POST /quotations or /quotations.json
   def create
    @quotation = Quotation.new(quotation_params)
    if @quotation.save
      generate_pdf(@quotation)
      redirect_to @quotation
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quotations/1 or /quotations/1.json
  def update
    if @quotation.update(quotation_params)
      generate_pdf(@quotation)
      redirect_to @quotation
    else
      render :edit
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
    @quotation.destroy
    redirect_to quotations_path, notice: 'Quotation was successfully voided.'
  end

  def approve
    pdf_path = @quotation.pdf_path

    if @quotation.approved!
      generate_pdf(@quotation)
      send_file pdf_path, type: 'application/pdf', disposition: 'inline'
      flash[:success] = "Quotation approved successfully!"
    else
      flash[:error] = "Failed to approve quotation."
    end

    redirect_to @quotation
  end

  def pending
    pdf_path = @quotation.pdf_path

    if @quotation.pending!
      generate_pdf(@quotation)
      send_file pdf_path, type: 'application/pdf', disposition: 'inline'
      flash[:success] = "Quotation pending successfully!"
    else
      flash[:error] = "Failed to pending quotation."
    end

    redirect_to @quotation
  end

  def reject
    if @quotation.rejected!
      flash[:success] = "Quotation rejected successfully!"
    else
      flash[:error] = "Failed to reject quotation."
    end

    redirect_to @quotation
  end

  private
    def generate_pdf(quotation)
      html = render_to_string(
        template: 'quotations/pdf_view',
        layout: 'pdf',
        locals: { quotation: quotation }
      )
      
      # Use absolute URL for FontAwesome CSS
      fontawesome_css_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" # Update to the correct version if necessary
      application_css_url = view_context.asset_url('application.css') # Full URL for production

      # Include both CSS files
      pdf = Grover.new(html, style_tag_options: [{ url: application_css_url }, { url: fontawesome_css_url }]).to_pdf
      quotation.save_pdf(pdf)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_quotation
      @quotation = Quotation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quotation_params
      params.require(:quotation).permit(
        :uid, :company_id, :client_id, :attention, :vessel, :subject, :user_id,
        :remarks, :payment, :lead_time, :warranty, :sub_total,
        :total, :vat, :additional_conditions, :preparer, :approver, :discount, :discount_rate,
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
