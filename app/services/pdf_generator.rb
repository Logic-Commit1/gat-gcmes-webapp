# app/services/pdf_generator_service.rb
class PdfGenerator
    def initialize(quotation)
      @quotation = quotation
    end
  
    def generate
      html = render_to_string(
        template: 'components/quotation/_pdf_layout',
        locals: { quotation: @quotation },
        print_background: true
      )
      
      Grover.new(html, emulate_media: 'print').to_pdf
    end
  
    private
  
    def render_to_string(template:, locals:)
      # Assuming you have a method to render the template to string
      ApplicationController.renderer.render(template: template, locals: locals)
    end
  end