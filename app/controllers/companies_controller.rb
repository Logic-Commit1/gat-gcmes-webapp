class CompaniesController < ApplicationController
    def show
        @company = Company.find(params[:id])
      end
      
      def clients
        company = Company.find(params[:id])
        clients = company.clients.select(:id, :name) # Only select necessary fields
        render json: clients
      end
end
