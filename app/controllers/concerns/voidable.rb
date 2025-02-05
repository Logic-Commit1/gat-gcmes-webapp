module Voidable
  extend ActiveSupport::Concern

  def unvoid
    # Find the record from deleted records
    @record = find_with_deleted
    
    # Attempt to restore the record and its associations
    if @record.restore
      # Restore associated products if they exist
      if @record.respond_to?(:products)
        @record.products.only_deleted.each do |product|
          product.restore
          # Restore associated specs and scopes
          product.specs.only_deleted.each(&:restore) if product.respond_to?(:specs)
          product.scopes.only_deleted.each(&:restore) if product.respond_to?(:scopes)
        end
      end

      # Restore associated particulars if they exist
      if @record.respond_to?(:particulars)
        @record.particulars.only_deleted.each(&:restore)
      end

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

  def delete
    @record = find_with_deleted
    @record.really_destroy!
    respond_to do |format|
      format.html { redirect_to voided_documents_path, notice: "#{@record.uid} was permanently deleted." }
      format.json { head :no_content }
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