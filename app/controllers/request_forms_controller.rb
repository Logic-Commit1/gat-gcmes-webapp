class RequestFormsController < ApplicationController
  before_action :set_request_form, only: %i[ show edit update approve pending void ]

  # GET /request_forms or /request_forms.json
  def index
    @request_forms = RequestForm.all
  end

  # GET /request_forms/1 or /request_forms/1.json
  def show
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
        particulars.concat(request_form.particulars)
      else
        products.concat(request_form.products)
      end
    end

    # You can choose to render either particulars or products based on your needs
    render json: { particulars: particulars, products: products }
    # if particulars.present? && products.present?
    # else if particulars.present? && products.present?
    #   render json: { products: products }
    # end
    
  end

  private
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
        particulars_attributes: [ :id, :name, :allowance, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy ],
        products_attributes: [ :id, :name, :quantity, :unit, :price, :discount, :brand, :description, :specs, :terms, :remarks, :image, :quotation_id, :canvass_id, :request_form_id, :purchase_order_id, :_destroy ]
        )
      rescue
        {}
    end
end
