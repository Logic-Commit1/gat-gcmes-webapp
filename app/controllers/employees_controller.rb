class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  # GET /employees or /employees.json
  def index
    @employees = User.latest_first

    if params[:query].present?
      @employees = @employees.where("email ILIKE :query OR department ILIKE :query", query: "%#{params[:query]}%")
    end

    if params[:date].present?
      date = Date.parse(params[:date])
      @employees = @employees.where("DATE(created_at) = ?", date)
    end

    @pagy, @employees = pagy(@employees)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("employees_table", 
          partial: "components/table_body", 
          locals: { documents: @employees, title: "Employees" })
      end
    end
  end

  def whitelisted
    @employees = Employee.latest_first
  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @employees = Employee.all
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to whitelisted_employees_path, notice: "Employee was successfully created." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Employee was successfully updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy!

    respond_to do |format|
      format.html { redirect_to whitelisted_employees_path, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(
        :name, 
        :contact_number, 
        :email,
        :department,
        contacts_attributes: [:id, :name, :_destroy, emails: [], contact_numbers: []]
      )
    end
end
