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
        send_file ActiveStorage::Blob.service.path_for(@resource.pdf_report.key), type: 'application/pdf', disposition: 'inline'
      else
        flash[:error] = "PDF report could not be generated - attachment failed"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "PDF report could not be generated"
      redirect_back(fallback_location: root_path) 
    end
  end

end 