class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy purge_attachment ]

  # GET /projects or /projects.json
  def index
    @projects = Project.latest_first
                      .search_by_term(params[:query])
                      .created_on_date(params[:date])

    @pagy, @projects = pagy(@projects)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "projects_table", 
          partial: "components/table_body", 
          locals: { documents: @projects, title: "Projects" }
        )
      end
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    @project.user = current_user
    
    # Handle file attachments
    if project_params[:work_acceptance_files].present?
      @project.work_acceptance_files.attach(project_params[:work_acceptance_files])
      @project.check_and_update_status
      return redirect_to @project, notice: 'Work acceptance files were successfully uploaded.'
    end

    if project_params[:delivery_receipt_files].present?
      @project.delivery_receipt_files.attach(project_params[:delivery_receipt_files])
      @project.check_and_update_status
      return redirect_to @project, notice: 'Delivery receipt files were successfully uploaded.'
    end

    # Handle other updates
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def purge_attachment
    attachment = params[:attachment_type] == 'work_acceptance' ? @project.work_acceptance_files : @project.delivery_receipt_files
    attachment.find(params[:attachment_id]).purge
    
    # Trigger status check after purging
    @project.check_and_update_status

    respond_to do |format|
      format.html { redirect_to @project, notice: 'File was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:company, :uid, :client_po, :status, :amount, :payment, :company_id, :po_number, :user_id, :supervisor, quotation_ids: [], work_acceptance_files: [], delivery_receipt_files: [])
    end
end
