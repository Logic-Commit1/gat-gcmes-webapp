module PrawnPdfGenerator
  extend ActiveSupport::Concern

  def download_pdf
    if @resource.generate_prawn
      if @resource.pdf_report.attached?
        send_file ActiveStorage::Blob.service.path_for(@resource.pdf_report.key), type: 'application/pdf', disposition: 'attachment'
      else
        flash[:error] = "PDF report could not be generated - attachment failed"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "PDF report could not be generated"
      redirect_back(fallback_location: root_path) 
    end
  end

  def print_pdf
    if @resource.generate_prawn
      if @resource.pdf_report.attached?
        pdf_path = ActiveStorage::Blob.service.path_for(@resource.pdf_report.key) rescue nil
        Rails.logger.info "📄 Serving PDF from: #{pdf_path}"
  
        if pdf_path && File.exist?(pdf_path)
          send_file pdf_path, type: 'application/pdf', disposition: 'inline'
        else
          Rails.logger.error "🚨 ERROR: ActiveStorage PDF file not found!"
          flash[:error] = "PDF report could not be found in storage"
          redirect_back(fallback_location: root_path)
        end
      else
        Rails.logger.error "🚨 ERROR: PDF attachment failed!"
        flash[:error] = "PDF report could not be generated - attachment failed"
        redirect_back(fallback_location: root_path)
      end
    else
      Rails.logger.error "🚨 ERROR: generate_prawn returned false!"
      flash[:error] = "PDF report could not be generated"
      redirect_back(fallback_location: root_path) 
    end
  end
  
end 