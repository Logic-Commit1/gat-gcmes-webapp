module PdfGenerator
  extend ActiveSupport::Concern

  def download_pdf
    pdf_path = @resource.pdf_path

    File.delete(pdf_path) if File.exist?(pdf_path)
    generate_pdf(@resource)

    send_file pdf_path, type: 'application/pdf', disposition: 'attachment'   
  end

  def print_pdf
    pdf_path = @resource.pdf_path

    File.delete(pdf_path) if File.exist?(pdf_path)
    generate_pdf(@resource)
    
    send_file pdf_path, type: 'application/pdf', disposition: 'inline'
  end

  private

  def generate_pdf(resource)
    html = render_to_string(
      template: "#{controller_name}/pdf_view",
      layout: 'pdf',
      locals: { controller_name.singularize.to_sym => resource }
    )
    
    # Use absolute URL for FontAwesome CSS
    fontawesome_css_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    application_css_url = view_context.asset_url('application.css')

    # Include both CSS files
    pdf = Grover.new(html, style_tag_options: [{ url: application_css_url }, { url: fontawesome_css_url }]).to_pdf
    resource.save_pdf(pdf)
  end
end 