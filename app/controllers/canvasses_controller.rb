class CanvassesController < ApplicationController
  layout 'pdf', only: :pdf_view

  before_action :set_canvass, only: %i[ show edit update approve pending void pdf_view ]

  # GET /canvasses or /canvasses.json
  def index
    @canvasses = Canvass.order(created_at: :desc)
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
    @canvass.destroy
    redirect_to canvasses_path, notice: 'Canvass was successfully voided.'
  end

  def approve
    if @canvass.approved!
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

  private
    def generate_pdf(canvass)
      html = render_to_string(
        template: 'canvasses/pdf_view',
        layout: 'pdf',
        locals: { canvass: canvass }
      )
      
      # Use absolute URL for FontAwesome CSS
      fontawesome_css_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" # Update to the correct version if necessary
      application_css_url = view_context.asset_url('application.css') # Full URL for production

      # Include both CSS files
      pdf = Grover.new(html, style_tag_options: [{ url: application_css_url }, { url: fontawesome_css_url }]).to_pdf
      canvass.save_pdf(pdf)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_canvass
      @canvass = Canvass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def canvass_params
      params.require(:canvass).permit(:uid, :company_id, :description, :quantity, :unit, :suppliers,
      products_attributes: [ :id, :name, :quantity, :unit, :price, :discount, :brand, :description, :specs, :terms, :remarks, :image, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy, :supplier_id, :_destroy ]
      )
    rescue
      {}
    end
end
