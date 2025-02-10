require 'benchmark'

module GroverPdfGenerator
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
    render_start_time = Time.now
    html = render_to_string(
      template: "#{controller_name}/pdf_view",
      layout: 'pdf',
      locals: { controller_name.singularize.to_sym => resource }
    )
    render_end_time = Time.now
    puts "Time taken to render HTML: #{render_end_time - render_start_time} seconds"

    # Use absolute URL for FontAwesome CSS
    fontawesome_css_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    application_css_url = view_context.asset_url('application.css')

    pdf_start_time = Time.now
    # Include both CSS files
    pdf = Grover.new(html, style_tag_options: [{ url: application_css_url }, { url: fontawesome_css_url }]).to_pdf
    pdf_end_time = Time.now
    puts "Time taken to convert HTML to PDF: #{pdf_end_time - pdf_start_time} seconds"

    resource.save_pdf(pdf)
  end
end 