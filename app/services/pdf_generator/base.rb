require 'prawn/icon'

module PdfGenerator
  class Base
    include StylingDefaults

    MANROPE_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-Regular.ttf'
    MANROPE_SEMI_BOLD_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-SemiBold.ttf'
    MANROPE_BOLD_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-Bold.ttf'

    GAT_LOGO_PATH = 'app/assets/images/gat-logo.png'
    GCMES_LOGO_PATH = 'app/assets/images/gcmes-logo.png'

    def initialize(document)
      @document = document
      
      Dir.mkdir("tmp/#{@document.class.name.underscore.pluralize}") unless Dir.exist?("tmp/#{@document.class.name.underscore.pluralize}")
      @path = Rails.root.join("tmp/#{@document.class.name.underscore.pluralize}", "#{@document.uid}.pdf")

    end

    def generate
      Prawn::Document.generate(
        @path,
        margin: 35,
        page_layout: :portrait,
        page_size: 'A4',
        compress: true,
        optimize_objects: true
      ) do |pdf|
        @pdf = pdf
        @document_width = @pdf.bounds.width

        setup_fonts
        @pdf.font('manrope')
        @pdf.font_size 7

        header

        @pdf.move_down 15

        specific_sub_header

        if @document.class.name == "Quotation"
          client_details
        end
        
        products_table
        
        if @document.class.name == "Quotation"
          totals_height = 100 # Approximate height for totals
          if @pdf.cursor < totals_height
            @pdf.start_new_page
          end

          totals_table

          terms_height = 100 # Approximate height for terms
          if @pdf.cursor < terms_height
            @pdf.start_new_page
          end
          
          terms_and_conditions
        end
        

        signatures_height = @document.class.name == "PurchaseOrder" ? 150 : 110 # Approximate height for signatures
        if @pdf.cursor < signatures_height
          @pdf.start_new_page
        end
        signatures_table

        @pdf.number_pages(
          "Page <page> of <total>",
          { start_count_at: 1, page_filter: :all, at: [@pdf.bounds.right - 500, 2], align: :right, size: 8}
        )
      end

      @path
    end

    private

    def setup_fonts
      @pdf.font_families.update(
        'manrope' => {
          normal: MANROPE_FONT_PATH,
          semi_bold: MANROPE_SEMI_BOLD_FONT_PATH,
          bold: MANROPE_BOLD_FONT_PATH
        }
      )
    end

    def cell_style
      { padding: default_padding, size: font_size, inline_format: true, align: align, border_width: 0.5 }
    end

    # def data_table(data, width = nil, styling = nil)
    #   width = @document_width if width.nil?
    #   styling = styling.nil? ? cell_style : styling

    #   @pdf.table(
    #     data,
    #     width: width,
    #     styling
    #   )
    # end



    def header
      # Contact details section
      @pdf.bounding_box([0, @pdf.cursor], width: 224, height: 68) do
        # Draw the gradient background before adding content
        @pdf.fill_gradient [0, @pdf.cursor], [224, @pdf.cursor - 68], 'ffdb57', 'fdae4e'
        @pdf.fill_rectangle [0, @pdf.cursor + 16], 224, 68 # Fill with gradient

        # Reset fill color for text
        @pdf.fill_color "000000"
        # Contact details with padding
        @pdf.bounding_box([0, 82], width: 224, height: 76) do
          address_data = [[@pdf.table_icon('fas-location-dot'), "#{@document.company.address[0..66]}\n#{@document.company.address[67..]}"],
                          [@pdf.table_icon('fas-phone'), "#{@document.company.contact_numbers.join(' | ')}"],
                            [@pdf.table_icon('fas-envelope'),"#{@document.company.emails.join(', ')}"] ]

          @pdf.table(
            address_data,
            width: 244,
            cell_style: {
              border_width: 0,
              padding: [4, 0],
              size: 6.5
            },
            column_widths: {
              0 => 20,
              1 => 224
            }
          ) do |table|
            table.column(0).style(align: :center, valign: :center)
          end
        end
      end

      # Logo section
      @pdf.bounding_box([224, @pdf.cursor + 68], width: 120, height: 68) do
        # Navy blue background
        @pdf.fill_color "000a52"
        @pdf.fill_rectangle [0, 84], 120, 68
        @pdf.fill_color "000000"

        # Logo
        logo_y_position = 80 - ((80 - 68) / 2) 
        logo_path = @document.company.code.downcase == "gat" ? GAT_LOGO_PATH : GCMES_LOGO_PATH
        if @document.company.code.downcase == "gat"
          @pdf.image logo_path, at: [27.5, logo_y_position], width: 66, height: 34
        else
          @pdf.image logo_path, at: [11.5, logo_y_position + 13], width: 95, height: 74
        end

        # Company name
        @pdf.fill_color "f5db07"
        company_name = @document.company.code.downcase == "gat" ? "GOLDEN ARROW TRADING" : ""
        @pdf.text_box company_name,
          at: [0, 32.5],
          width: 120,
          align: :center,
          size: 7.5,
          style: :bold
        @pdf.fill_color "000000"
      end

      # Document name and uid
      @pdf.bounding_box([380, @pdf.cursor + 80], width: 145, height: 72) do
        @pdf.move_down 10

        @pdf.text "#{@document.class.name.titleize}", size: 16, style: :bold, align: :right
        @pdf.text "#{@document.uid}", size: 9, align: :right
      end
    end

    def date_requested
      @pdf.text "Date Requested: #{@document.created_at.strftime("%B %d, %Y")}", align: :right
    end    

    private

    def number_with_precision(number, precision: 2, delimiter: ',')
      whole, decimal = number.to_s.split('.')
      whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(delimiter).reverse
      [whole_with_commas, decimal&.ljust(precision, '0')].compact.join('.')
    end

    
  end
end