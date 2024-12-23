class ParticularsController < ApplicationController
  before_action :set_particular, only: %i[ show edit update destroy ]

  # GET /particulars or /particulars.json
  def index
    @particulars = Particular.all
  end

  # GET /particulars/1 or /particulars/1.json
  def show
  end

  # GET /particulars/new
  def new
    @particular = Particular.new
  end

  # GET /particulars/1/edit
  def edit
  end

  # POST /particulars or /particulars.json
  def create
    @particular = Particular.new(particular_params)

    respond_to do |format|
      if @particular.save
        format.html { redirect_to particular_url(@particular), notice: "Particular was successfully created." }
        format.json { render :show, status: :created, location: @particular }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @particular.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /particulars/1 or /particulars/1.json
  def update
    respond_to do |format|
      if @particular.update(particular_params)
        format.html { redirect_to particular_url(@particular), notice: "Particular was successfully updated." }
        format.json { render :show, status: :ok, location: @particular }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @particular.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /particulars/1 or /particulars/1.json
  def destroy
    @particular.destroy!

    respond_to do |format|
      format.html { redirect_to particulars_url, notice: "Particular was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_particular
      @particular = Particular.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def particular_params
      params.require(:particular).permit(:name, :allowance, :request_form_id, :remarks)
    end
end
