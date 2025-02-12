module PrawnPdfGenerator
  extend ActiveSupport::Concern

  def download_pdf
    if @resource.generate_prawn
      if @resource.pdf_report.attached?
        pdf_url = @resource.pdf_report.url
        
        if pdf_url.present?
          redirect_to pdf_url
        else
          flash[:error] = "PDF report could not be generated - attachment failed"
          redirect_back(fallback_location: root_path)
        end
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
        pdf_url = @resource.pdf_report.url
        Rails.logger.info "📄 Serving PDF from: #{pdf_url}"
  
        if pdf_url.present?
          redirect_to pdf_url
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