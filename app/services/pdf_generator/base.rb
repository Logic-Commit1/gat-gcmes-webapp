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
        margin: 30,
        page_layout: :portrait,
        page_size: 'A4',
        compress: true,
        optimize_objects: true
      ) do |pdf|
        @pdf = pdf
        @document_width = @pdf.bounds.width

        setup_fonts
        @pdf.font('manrope')
        @pdf.font_size 8

        header

        @pdf.move_down 15

        specific_sub_header

        # date_requested

        @pdf.move_down 5

        if @document.class.name == "Quotation" || @document.class.name == "PurchaseOrder"
          customer_details
        end

        if @document.class.name == "Quotation" || @document.class.name == "PurchaseOrder"
          subject_line
        end



        products_table

        # if @pdf.cursor < 100
        #   @pdf.start_new_page
        # else
        #   # @pdf.move_cursor_to 100 # Move to height points from bottom of page
        #   @pdf.move_down 20
        # end


        # totals_table

        
        # @pdf.move_down 20

        # terms_and_conditions
        # remaining_space = @pdf.cursor
        # signatures_height = 150 # Approximate height needed for signatures section

        # if remaining_space < signatures_height + 20
        #   @pdf.start_new_page
        # else
        #   @pdf.move_down 20 # Move to 150 points from bottom of page
        # end
        signatures_table

        @pdf.number_pages(
          # "Report ID: #{@report.uid} || Peak NDT Solutions, 4906 Ambassador Caffery Parkway building F, Lafayette, LA 70583 Page <page> of <total>",
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
      @pdf.bounding_box([0, @pdf.cursor], width: 250, height: 80) do
        # Fill background with orange gradient (closest approximation in PDF)
        @pdf.fill_color "fdae4e"
        @pdf.fill_rectangle [0, 84], 250, 80
        @pdf.fill_color "000000"

        # Contact details with padding
        @pdf.bounding_box([8, 76], width: 244, height: 76) do
            address_data = [[@pdf.table_icon('fas-location-dot'), "#{@document.company.address}"],
                            [@pdf.table_icon('fas-phone'), "#{@document.company.contact_numbers.join(' | ')}"],
                            [@pdf.table_icon('fas-envelope'),"#{@document.company.emails.join(', ')}"] ]

          @pdf.table(
            address_data,
            width: 244,
            cell_style: {
              border_width: 0,
              padding: [3, 2],
              size: 8
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
      @pdf.bounding_box([250, @pdf.cursor + 80], width: 120, height: 80) do
        # Navy blue background
        @pdf.fill_color "000a52"
        @pdf.fill_rectangle [0, 84], 120, 80
        @pdf.fill_color "000000"

        # Logo
        logo_y_position = 80 - ((80 - 60) / 2) 
        logo_path = @document.company.code.downcase == "gat" ? GAT_LOGO_PATH : GCMES_LOGO_PATH
        @pdf.image logo_path, at: [24.5, logo_y_position], width: 76, height: 40

        # Company name
        @pdf.fill_color "f5db07"
        company_name = @document.company.code.downcase == "gat" ? "GOLDEN ARROW TRADING" : ""
        @pdf.text_box company_name,
          at: [0, 22.5],
          width: 120,
          align: :center,
          style: :bold
        @pdf.fill_color "000000"
      end

      # Document name and uid
      @pdf.bounding_box([390, @pdf.cursor + 80], width: 145, height: 84) do
        @pdf.move_down 10

        @pdf.text "#{@document.class.name.titleize}", size: 20, style: :bold, align: :right
        @pdf.text "#{@document.uid}", align: :right
      end
    end

    def date_requested
      @pdf.text "Date Requested: #{@document.created_at.strftime("%B %d, %Y")}", align: :right
    end

    def customer_details
      data = [
        [{content: "Customer Details", colspan: 2}],
        ["Company Name", @document.client.name],
        ["Business Address", @document.client.address],
        ["Attention", @document.attention&.titleize],
        ["Vessel", @document.vessel&.upcase]
      ]

      @pdf.bounding_box([0, @pdf.cursor], width: @document_width) do
        @pdf.table(data, width: @document_width) do |t|
          t.row(0).font_style = :bold
          t.row(0).align = :center
          t.row(0).background_color = "DDDDDD"
          t.cells.padding = 8
          t.cells.borders = [:bottom, :top, :left, :right]
          t.column(0).width = @document_width * 0.2
        end
      end
      
      @pdf.move_down 20
    end

    def subject_line
      @pdf.text "Subject: #{@document.subject}", style: :bold

      @pdf.move_down 10
    end


    def terms_and_conditions
      @pdf.text "TERMS AND CONDITIONS", style: :bold
      @pdf.move_down 10

      terms = []
      terms << ["Lead time", @document.lead_time] if @document.lead_time.present?
      terms << ["Duration", @document.duration] if @document.duration.present?
      terms << ["Warranty", @document.warranty] if @document.warranty.present?
      terms << ["Payment", @document.payment] if @document.payment.present?

      @pdf.table(terms, width: @document_width) do |t|
        t.cells.borders = [:bottom, :top, :left, :right]
        t.cells.padding = [4, 8]
        # t.cells.borders = []
        t.column(0).font_style = :bold
        t.column(0).width = 55
        # t.column(0).padding_left = 0
        # t.column(0).align = :left
      end
    end

    

    private

    def number_with_precision(number, precision: 2, delimiter: ',')
      whole, decimal = number.to_s.split('.')
      whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(delimiter).reverse
      [whole_with_commas, decimal&.ljust(precision, '0')].compact.join('.')
    end

    def build_specs_and_scopes_content(specs, scopes)
      content = ""
      
      if specs.any?
        content += "SPECS:\n\n"
        specs.each do |spec|
          content += "#{spec.name} : #{spec.value}\n"
        end
      end

      if specs.any? && scopes.any?
        content += "\n"
      end

      if scopes.any?
        content += "SCOPE OF WORK\n\n"
        scopes.each do |scope|
          content += "* #{scope.name}\n"
        end
      end

      content
    end

    # def apply_column_widths(table)
    #   table.column(0).width = 30
    #   table.column(1).width = (@document_width) * 0.5
    #   table.column(2).width = 30
    #   table.column(3).width = 40
    #   table.columns(4).width = (@document_width) * 0.16
    # end

    
    def totals_table
      # Position the table at the right side by calculating offset from right margin
      table_width = 180
      x_position = @document_width - table_width 
      
      @pdf.bounding_box([x_position, @pdf.cursor], width: table_width) do
        data = [["SUB TOTAL", "PHP #{number_with_precision(@document.sub_total)}"]]
        
        if @document.discount > 0
          data << ["DISCOUNT (#{@document.discount_rate.to_i}%)", 
                  "- #{number_with_precision(@document.discount)}"]
        end
        
        data << ["12% VAT", "#{number_with_precision(@document.vat)}"]
        data << ["TOTAL", "PHP #{number_with_precision(@document.total)}"]

        @pdf.table(data, width: table_width - 20) do |t|
          t.cells.padding = [2, 8]
          t.cells.borders = []
          t.cells.font_style = :semi_bold
          t.column(1).align = :right
          t.row(-1).borders = [:top] # Add top border to last row
          t.row(-1).background_color = "F8D251"
          t.row(-1).text_color = "D60000"
        end
      end
    end
  end
end