class PdfGenerator
    MANROPE_FONT_PATH = 'app/assets/fonts/Manrope-Regular.ttf'
    MANROPE_BOLD_FONT_PATH = 'app/assets/fonts/Manrope-Bold.ttf'
    GAT_LOGO_PATH = 'app/assets/images/gat-logo.png'
    GCMES_LOGO_PATH = 'app/assets/images/gcmes-logo.png'

    def initialize
      @pdf = Prawn::Document.new(margin: 50)
      @document_width = @pdf.bounds.width
      @pdf.font_families.update(
        'manrope' => {
          normal: MANROPE_FONT_PATH,
          bold: MANROPE_BOLD_FONT_PATH
        }
      )
      @pdf.font 'manrope'
    end

    def generate(quotation)
      # Generate the PDF content
      header
      date_requested(quotation)
      customer_details(quotation)
      subject_line(quotation)
      products_table(quotation)
      totals_table(quotation)
      terms_and_conditions(quotation)
      signatures(quotation)
      
      # Create a temporary file with the PDF content
      temp_file = Tempfile.new(['quotation', '.pdf'])
      temp_file.binmode
      temp_file.write(@pdf.render)
      temp_file.close
      
      temp_file.path
    ensure
      # Make sure to close and unlink the temp file if it exists
      temp_file&.close
    end

    private

    # ... rest of the methods remain the same ... 