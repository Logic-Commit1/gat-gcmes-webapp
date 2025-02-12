module PrawnPdfGenerator
  extend ActiveSupport::Concern

  def download_pdf
    if @resource.generate_prawn
      if @resource.pdf_report.attached?
        begin
          # Download the PDF file content
          pdf_content = @resource.pdf_report.download
          
          # Set filename based on resource type and ID
          filename = "#{@resource.class.name.downcase}_#{@resource.id}.pdf"
          
          # Send the file as a download attachment
          send_data pdf_content, 
                    filename: filename,
                    type: 'application/pdf',
                    disposition: 'attachment'
        rescue StandardError => e
          Rails.logger.error "🚨 ERROR downloading PDF: #{e.message}"
          flash[:error] = "Could not download PDF file"
          redirect_back(fallback_location: root_path)
        end
      else
        Rails.logger.error "🚨 ERROR: PDF attachment missing!"
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
        # ✅ Generate a short-lived signed URL (5 min expiry)
        pdf_url = @resource.pdf_report.url(expires_in: 5.minutes)
  
        # ✅ Extract host from Cloudflare R2 URL
        allowed_hosts = ["r2.cloudflarestorage.com"]
  
        begin
          pdf_host = URI.parse(pdf_url).host
        rescue URI::InvalidURIError
          Rails.logger.error "🚨 ERROR: Invalid PDF URL: #{pdf_url}"
          flash[:error] = "Invalid PDF URL."
          return redirect_back(fallback_location: root_path)
        end
  
        # ✅ Skip host restriction in development
        if Rails.env.development? || allowed_hosts.any? { |host| pdf_host.include?(host) }
          Rails.logger.info "📄 Redirecting to Cloudflare R2 URL"
          redirect_to pdf_url, allow_other_host: true
        else
          Rails.logger.error "🚨 ERROR: Unsafe redirect attempted to #{pdf_url}"
          flash[:error] = "Invalid PDF URL."
          redirect_back(fallback_location: root_path)
        end
      else
        Rails.logger.error "🚨 ERROR: PDF attachment missing!"
        flash[:error] = "PDF report could not be generated."
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "PDF report generation failed."
      redirect_back(fallback_location: root_path)
    end
  end
  
end 