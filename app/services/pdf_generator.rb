# app/services/pdf_generator_service.rb
class PdfGenerator
  def self.generate(quotation, view_context)
    html = view_context.render_to_string(
      template: 'quotations/pdf_view',
      layout: 'pdf',
      locals: { quotation: quotation }
    )
    css_url = view_context.asset_url('application.css')
    Grover.new(html, style_tag_options: [{ url: css_url }]).to_pdf
  end
end

  # def self.generate(quotation, view_context)
  #   html = view_context.render_to_string(
  #     template: 'quotations/pdf_view',
  #     layout: 'pdf',
  #     locals: { quotation: quotation }
  #   )
  #   css_url = view_context.asset_url('application.css')
  #   Grover.new(html, style_tag_options: [{ url: css_url }]).to_pdf
  # end