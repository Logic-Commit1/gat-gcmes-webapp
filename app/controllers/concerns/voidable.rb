module Voidable
  extend ActiveSupport::Concern

  def unvoid
    # Find the record from deleted records
    @record = find_with_deleted
    
    # Attempt to restore the record
    if @record.restore
      respond_to do |format|
        format.html { 
          flash[:notice] = "#{@record.uid} was successfully restored."
          redirect_to voided_documents_path
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:alert] = "Failed to restore #{model_class.name.titleize}."
          redirect_to voided_documents_path
        }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_with_deleted
    model_class.with_deleted.find(params[:id])
  end

  def model_class
    controller_name.classify.constantize
  end
end 