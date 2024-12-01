class CanvassesController < ApplicationController
  before_action :set_canvass, only: %i[ show edit update destroy ]

  # GET /canvasses or /canvasses.json
  def index
    @canvasses = Canvass.all
  end

  # GET /canvasses/1 or /canvasses/1.json
  def show
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
  def destroy
    @canvass.destroy!

    respond_to do |format|
      format.html { redirect_to canvasses_url, notice: "Canvass was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
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
