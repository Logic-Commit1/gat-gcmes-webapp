class SuppliersController < ApplicationController
  include Authorizable
  before_action :authorize_purchasing!
  before_action :set_supplier, only: %i[ show edit update destroy ]

  # GET /suppliers or /suppliers.json
  def index
    @suppliers = Supplier.latest_first

    if params[:query].present?
      @suppliers = @suppliers.joins(:company).where(
        "suppliers.code ILIKE :query OR suppliers.name ILIKE :query OR companies.code ILIKE :query", 
        query: "%#{params[:query]}%"
      )
    end

    if params[:date].present?
      date = Date.parse(params[:date])
      @suppliers = @suppliers.where("DATE(created_at) = ?", date)
    end

    @pagy, @suppliers = pagy(@suppliers)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("suppliers_table", 
          partial: "components/table_body", 
          locals: { documents: @suppliers, title: "Suppliers" })
      end
    end
  end

  # GET /suppliers/1 or /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    @supplier.contacts.build
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers or /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to supplier_url(@supplier), notice: "Supplier was successfully created." }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1 or /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to supplier_url(@supplier), notice: "Supplier was successfully updated." }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1 or /suppliers/1.json
  def destroy
    @supplier.destroy!

    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: "Supplier was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def supplier_params
      params.require(:supplier).permit(
        :name, 
        :code, 
        :address, 
        :tin, 
        :company_id, 
        contacts_attributes: [
          :id, 
          :salutation,
          :name, 
          { emails: [] }, 
          { contact_numbers: [] }, 
          :_destroy
        ]
      )
    end
end
