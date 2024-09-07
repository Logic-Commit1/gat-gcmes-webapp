class CompaniesController < ApplicationController
    def show
        @company = Company.find(params[:id])
      end
      
      def clients
        company = Company.find(params[:id])
        clients = company.clients.select(:id, :name) # Only select necessary fields
        render json: clients
      end

      def suppliers
        company = Company.find(params[:id])
        suppliers = company.suppliers.select(:id, :name) # Only select necessary fields
        render json: suppliers
      end

      def request_forms
        company = Company.find(params[:id])
        request_forms = company.request_forms.select(:id, :uid) # Only select necessary fields
        render json: request_forms
      end

      def projects
        company = Company.find(params[:id])
        projects = company.projects.select(:id, :uid) # Only select necessary fields
        render json: projects
      end

      def canvasses
        company = Company.find(params[:id])
        canvasses = company.canvasses.select(:id, :uid) # Only select necessary fields
        render json: canvasses
      end

      def quotations
        company = Company.find(params[:id])
        quotations = company.quotations.select(:id, :uid) # Only select necessary fields
        render json: quotations
      end

      
end
