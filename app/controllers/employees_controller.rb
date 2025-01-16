class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ promote demote ]

  # GET /employees or /employees.json
  def index
    @employees = User.latest_first
                    .search_by_term(params[:query])
                    .created_on_date(params[:date])

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

  def promote
    if @user&.promote!
      respond_to do |format|
        format.turbo_stream { 
          flash.now[:notice] = "Employee was successfully promoted to #{@user.role.humanize}."
          render turbo_stream: [
            turbo_stream.update("flash", partial: "components/alerts"),
            turbo_stream.update("employees_table", partial: "components/table_body", locals: { documents: User.latest_first, title: "Employees" })
          ]
        }
        format.html { redirect_back(fallback_location: employees_path, notice: "Employee was successfully promoted.") }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          flash.now[:alert] = "Unable to promote employee."
          render turbo_stream: turbo_stream.update("flash", partial: "components/alerts")
        }
        format.html { redirect_back(fallback_location: employees_path, alert: "Unable to promote employee.") }
      end
    end
  end

  def demote
    if @user&.demote!
      respond_to do |format|
        format.turbo_stream { 
          flash.now[:notice] = "Employee was successfully demoted to #{@user.role.humanize}."
          render turbo_stream: [
            turbo_stream.update("flash", partial: "components/alerts"),
            turbo_stream.update("employees_table", partial: "components/table_body", locals: { documents: User.latest_first, title: "Employees" })
          ]
        }
        format.html { redirect_back(fallback_location: employees_path, notice: "Employee was successfully demoted.") }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          flash.now[:alert] = "Unable to demote employee."
          render turbo_stream: turbo_stream.update("flash", partial: "components/alerts")
        }
        format.html { redirect_back(fallback_location: employees_path, alert: "Unable to demote employee.") }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
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
