class CompaniesController < ApplicationController
  before_action :set_company, only: [:edit, :update, :destroy, :clients, :suppliers, :order_request_forms, :projects, :canvasses, :quotations]

  def new
    @company = Company.new
  end

  def edit
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to new_company_path, notice: 'Company was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully deleted.'
  end

  def clients
    clients = @company.clients.select(:id, :name).order(:name)
    render json: clients
  end

  def suppliers
    suppliers = @company.suppliers.select(:id, :name).order(:name)
    render json: suppliers
  end

  def order_request_forms
    order_request_forms = @company.request_forms.Order.select(:id, :uid)
    render json: order_request_forms
  end

  def projects
    projects = @company.projects.select(:id, :uid).order(created_at: :desc)
    render json: projects
  end

  def canvasses
    canvasses = @company.canvasses.select(:id, :uid)
    render json: canvasses
  end

  def quotations
    quotations = @company.quotations.select(:id, :uid).order(created_at: :desc)
    render json: quotations
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :code, :address, :tin, :contact_numbers_string, :emails_string)
  end
end
