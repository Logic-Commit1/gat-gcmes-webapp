class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]

  # GET /clients or /clients.json
  def index
    @clients = Client.order(created_at: :desc)

    if params[:query].present?
      # @clients = @clients.search_by_term(params[:query])
      @clients = @clients.joins(:company).where(
        "clients.code ILIKE :query OR clients.name ILIKE :query OR companies.code ILIKE :query", 
        query: "%#{params[:query]}%"
      )
    end

    if params[:date].present?
      date = Date.parse(params[:date])
      @clients = @clients.where("DATE(created_at) = ?", date)
    end

    @pagy, @clients = pagy(@clients)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("clients_table", 
          partial: "components/table_body", 
          locals: { documents: @clients, title: "Clients" })
      end
    end
  end

  # GET /clients/1 or /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
    @client.contacts.build
  end

  # GET /clients/1/edit
  def edit
  end

  # Check if code exists
  def check_code
    exists = Client.where.not(id: params[:id])
                  .where("LOWER(code) = LOWER(?)", params[:code])
                  .exists?
    render json: { exists: exists }
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy!

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(
        :name, 
        :code, 
        :address, 
        :tin, 
        :company_id, 
        contacts_attributes: [
          :id, 
          :name, 
          { emails: [] }, 
          { contact_numbers: [] }, 
          :_destroy
        ]
      )
    end
end
