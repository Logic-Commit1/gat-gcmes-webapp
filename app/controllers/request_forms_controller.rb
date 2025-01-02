class RequestFormsController < ApplicationController
  layout 'pdf', only: :pdf_view

  before_action :set_request_form, only: %i[ show edit update approve pending void pdf_view ]

  # GET /request_forms or /request_forms.json
  def index
    @request_forms = RequestForm.latest_first

    if params[:query].present?
      @request_forms = @request_forms.search_by_term(params[:query])
    end
    
    if params[:date].present?
      @request_forms = @request_forms.created_on_date(Date.parse(params[:date]))
    end

    @pagy, @request_forms = pagy(@request_forms)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "request_forms_table", 
          partial: "components/table_body", 
          locals: { documents: @request_forms, title: "Request Forms" }
        )
      end
    end
  end

  # GET /request_forms/1 or /request_forms/1.json
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

  # GET /request_forms/new
  def new
    @request_form = RequestForm.new(request_form_params)
    @request_form.products.build
    @request_form.particulars.build
  end

  # GET /request_forms/1/edit
  def edit
  end

  # POST /request_forms or /request_forms.json
  def create
    @request_form = RequestForm.new(request_form_params)

    respond_to do |format|
      if @request_form.save
        format.html { redirect_to request_form_url(@request_form), notice: "Request form was successfully created." }
        format.json { render :show, status: :created, location: @request_form }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_forms/1 or /request_forms/1.json
  def update
    respond_to do |format|
      if @request_form.update(request_form_params)
        format.html { redirect_to request_form_url(@request_form), notice: "Request form was successfully updated." }
        format.json { render :show, status: :ok, location: @request_form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /request_forms/1 or /request_forms/1.json
  # def destroy
  #   @request_form.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to request_forms_url, notice: "Request form was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  def void
    @request_form.destroy
    redirect_to request_forms_path, notice: 'Request form was successfully voided.'
  end

  def approve
    if @request_form.approved!
      flash[:success] = "Request form approved successfully!"
    else
      flash[:error] = "Failed to approve request form."
    end

    redirect_to @request_form
  end

  def pending
    if @request_form.pending!
      flash[:success] = "Request form pending successfully!"
    else
      flash[:error] = "Failed to pending request form."
    end

    redirect_to @request_form
  end

  def items
    request_form_ids = params[:request_form_ids].split(',').map(&:to_i)
    request_forms = RequestForm.where(id: request_form_ids)

    particulars = []
    products = []

    request_forms.each do |request_form|
      if request_form.request_type == "Allowance"
        particulars.concat(request_form.particulars.map { |p| 
          {
            id: p.id,
            name: p.name,
            allowance: p.allowance,
            remarks: p.remarks
          }
        })
      else
        products.concat(request_form.products.map { |p| 
          {
            id: p.id,
            name: p.name,
            price: p.price,
            quantity: p.quantity,
            discount: p.discount,
            unit: p.unit,
            description: p.description,
          }
        })
      end
    end

    render json: { particulars: particulars, products: products }
  end

  private
    def generate_pdf(request_form)
      html = render_to_string(
        template: 'request_forms/pdf_view',
        layout: 'pdf',
        locals: { request_form: request_form }
      )
      
      # Use absolute URL for FontAwesome CSS
      fontawesome_css_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" # Update to the correct version if necessary
      application_css_url = view_context.asset_url('application.css') # Full URL for production

      # Include both CSS files
      pdf = Grover.new(html, style_tag_options: [{ url: application_css_url }, { url: fontawesome_css_url }]).to_pdf
      request_form.save_pdf(pdf)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_request_form
      @request_form = RequestForm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_form_params
      params.require(:request_form).permit(
        :uid, :request_type, :vehicle, :start_travel_date, :end_travel_date, :destination, :total,
        :remarks, :fuel_gauge, :easy_trip_balance, :sweep_balance,
        :requester, :checker, :procurer, :pre_approver, :approver,
        :canvass_id, :quotation_id, :company_id, :project_id,
        particulars_attributes: [ :id, :name, :allowance, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy, :remarks ],
        products_attributes: [ :id, :name, :quantity, :unit, :price, :discount, :brand, :description, :specs, :terms, :remarks, :image, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy ]
        )
      rescue
        {}
    end
end
