require 'prawn/icon'

class PrawnPdfGenerator
    MANROPE_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-Regular.ttf'
    MANROPE_SEMI_BOLD_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-SemiBold.ttf'
    MANROPE_BOLD_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-Bold.ttf'
    GAT_LOGO_PATH = 'app/assets/images/gat-logo.png'
    GCMES_LOGO_PATH = 'app/assets/images/gcmes-logo.png'

    def initialize(document)
      Dir.mkdir('tmp/prawn/documents') unless Dir.exist?('tmp/prawn/documents')
      @document = document
      @path = Rails.root.join('tmp/prawn/documents', "#{@document.uid}.pdf")

    end

    def generate
      Prawn::Document.generate(
        @path,
        margin: 20,
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

        date_requested(@document)

        @pdf.move_down 5

        customer_details(@document)

        @pdf.move_down 20

        subject_line(@document)

        @pdf.move_down 10

        products_table(@document)

        remaining_space = @pdf.cursor
        totals_height = 100 # Approximate height needed for totals table

        if remaining_space < totals_height
          @pdf.start_new_page
        else
          @pdf.move_cursor_to totals_height # Move to height points from bottom of page
        end

        # @pdf.move_down 20

        totals_table(@document)

        
        @pdf.move_down 20

        terms_and_conditions(@document)
        remaining_space = @pdf.cursor
        signatures_height = 150 # Approximate height needed for signatures section

        if remaining_space < signatures_height + 20
          @pdf.start_new_page
        else
          @pdf.move_down 20 # Move to 150 points from bottom of page
        end
        signatures(@document)

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

    def header
      # Contact details section
      @pdf.bounding_box([0, @pdf.cursor], width: 250, height: 80) do
        # Fill background with orange gradient (closest approximation in PDF)
        @pdf.fill_color "fdae4e"
        @pdf.fill_rectangle [0, 84], 250, 80
        @pdf.fill_color "000000"

        # Contact details with padding
        # @pdf.font('manrope', size: 8) do
          @pdf.bounding_box([8, 76], width: 244, height: 76) do
            # @pdf.icon "<icon size='8'>fas-location-dot</icon>", inline_format: true
            # @pdf.text_box "#{@document.company.address}", padding_left: 80

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
            # @pdf.move_down 8
            # @pdf.icon "<icon size='8'>fas-phone</icon> ", inline_format: true
            # @pdf.move_down 8
            # @pdf.icon "<icon size='8'>fas-envelope</icon> #{@document.company.emails.join(', ')}", inline_format: true
          end
        # end
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
        # @pdf.font('manrope', size: 10, style: :bold) do
          @pdf.fill_color "f5db07"
          company_name = @document.company.code.downcase == "gat" ? "GOLDEN ARROW TRADING" : ""
          @pdf.text_box company_name,
            at: [0, 22.5],
            width: 120,
            align: :center,
            style: :bold
        # end
        @pdf.fill_color "000000"
      end

      # Document name and uid
      @pdf.bounding_box([410, @pdf.cursor + 80], width: 145, height: 84) do
        @pdf.move_down 10

        @pdf.text "#{@document.class.name.titleize}", size: 20, style: :bold, align: :right
        @pdf.text "#{@document.uid}", align: :right
      end
    end

    def date_requested(document)
      @pdf.text "Date Requested: #{document.created_at.strftime("%B %d, %Y")}", align: :right
    end

    def customer_details(document)
      data = [
        [{content: "Customer Details", colspan: 2}],
        ["Company Name", document.client.name],
        ["Business Address", document.client.address],
        ["Attention", document.attention&.titleize],
        ["Vessel", document.vessel&.upcase]
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
      
    end

    def subject_line(document)
      @pdf.text "Subject: #{document.subject}", style: :bold
    end

    def products_table(document)
      products = document.deleted? ? document.products.with_deleted : document.products
      
      draw_products_header
      
      products.each_with_index do |product, index|
        draw_product_row(product, index)
        draw_specs_and_scopes(product)
        draw_product_image(product)
        @pdf.move_down 10
      end
    end

    

    def terms_and_conditions(document)
      @pdf.text "TERMS AND CONDITIONS", style: :bold
      @pdf.move_down 10

      terms = []
      terms << ["Lead time", document.lead_time] if document.lead_time.present?
      terms << ["Duration", document.duration] if document.duration.present?
      terms << ["Warranty", document.warranty] if document.warranty.present?
      terms << ["Payment", document.payment] if document.payment.present?

      @pdf.table(terms, width: @document_width) do |t|
        t.cells.borders = [:bottom, :top, :left, :right]
        t.cells.padding = [4, 8]
        # t.cells.borders = []
        t.column(0).font_style = :bold
        t.column(0).width = 60
        # t.column(0).padding_left = 0
        # t.column(0).align = :left
      end
    end

    def signatures(document)
      # @pdf.text "Note: This document is not valid without manager's signature", align: :center
      @pdf.text "For further information please don't hesitate to contact us", align: :center
      @pdf.move_down 10

      # Initialize base data structure with headers
      data = [
        ["Conforme by", "Prepared by", "Approved by"],
        ["", "", ""],
        ["","",""]
      ]

      # Handle user signature (Prepared by - middle column)
      if document.user&.signature&.attached?
        begin
          signature_from_object = document.user.signature.variant(resize_to_limit: [110, 38])
          signature = StringIO.open(signature_from_object.download)
          data[1][1] = { image: signature, position: :center, scale: 0.6 }
          data[2][1] = "#{document.user&.first_name&.titleize} #{document.user&.last_name&.titleize}"
        rescue ActiveStorage::FileNotFoundError
          document.user.signature.purge if document.user.signature.attached?
        end
      end

      # Handle approver signature (Approved by - right column)
      if document.approved? && document.approver&.signature&.attached?
        begin
          approver_signature_from_object = document.approver.signature.variant(resize_to_limit: [110, 38])
          approver_signature = StringIO.open(approver_signature_from_object.download)
          data[1][2] = { image: approver_signature, position: :center, scale: 0.6 }
          data[2][2] = "#{document.approver&.first_name&.titleize} #{document.approver&.last_name&.titleize}"
        rescue ActiveStorage::FileNotFoundError
          document.approver.signature.purge if document.approver.signature.attached?
        end
      end

      # Draw the table with styling
      @pdf.bounding_box([0, @pdf.cursor], width: @document_width) do
        @pdf.table(data, width: @document_width) do |t|
          t.row(0).font_style = :bold
          t.row(0).background_color = "DDDDDD"
          t.row(0).align = :center
          t.row(0).borders = [:bottom, :top, :left, :right]
          t.row(1).height = 30
          t.row(1).borders = [:left, :right]
          t.row(1).padding = [8, 8, 0, 8]
          t.row(2).borders = [:left, :right, :bottom] 
          t.row(2).padding = [0, 8, 8, 8]
          t.row(0).padding = 8
          t.cells.align = :center
        end
      end

    end

    private

    def number_with_precision(number, precision: 2, delimiter: ',')
      whole, decimal = number.to_s.split('.')
      whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(delimiter).reverse
      [whole_with_commas, decimal&.ljust(precision, '0')].compact.join('.')
    end

    def draw_products_header
      headers = [["SN", "Description", "Qty", "U/M", "Unit Price", "Total Amount"]]

      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
        t.columns(2..6).align = :right
      end
    end

    def draw_product_row(product, index)
      data = [
        [index + 1, product.name, product.quantity, product.unit.upcase, 
         "PHP #{number_with_precision(product.price)}", 
         "PHP #{number_with_precision(product.total)}"]
      ]
      
      @pdf.table(data, width: @document_width, cell_style: {valign: :center}) do |t|
        t.cells.padding = 8
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
        t.column(0).align = :center
        t.column(1).align = :left
        t.columns(2..6).align = :right
      end
    end

    def draw_specs_and_scopes(product)
      specs = product.deleted? ? product.specs.with_deleted : product.specs
      scopes = product.deleted? ? product.scopes.with_deleted : product.scopes

      return unless specs.any? || scopes.any?

      content = build_specs_and_scopes_content(specs, scopes)
      
      @pdf.table([[nil, content, "", "", "", "", ""]], width: @document_width) do |t|
        t.cells.padding = 8
        t.cells.borders = []
        t.column(1).borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
      end
    end
    

    def draw_product_image(product)
      return unless product.image.attached?

      begin
        image_data = product.image.download
        image_path = "tmp/product_image_#{product.id}.jpg"
        File.binwrite(image_path, image_data)
        
        @pdf.table([[nil, { image: image_path, position: :left, fit: [100, 100] }, 
                    "", "", "", "", ""]], width: @document_width) do |t|
          t.cells.padding = 8
          t.cells.borders = []
          t.column(1).borders = [:bottom, :left, :right]
          apply_column_widths(t)
        end
        
        File.delete(image_path) if File.exist?(image_path)
      rescue ActiveStorage::FileNotFoundError
        product.image.purge if product.image.attached?
      end
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

    def apply_column_widths(table)
      table.column(0).width = 30
      table.column(1).width = (@document_width) * 0.5
      table.column(2).width = 30
      table.column(3).width = 40
      table.columns(4).width = (@document_width) * 0.16
    end

    
    def totals_table(document)
      # Position the table at the right side by calculating offset from right margin
      table_width = 180
      x_position = @document_width - table_width 
      
      @pdf.bounding_box([x_position, @pdf.cursor], width: table_width) do
        data = [["SUB TOTAL", "PHP #{number_with_precision(document.sub_total)}"]]
        
        if document.discount > 0
          data << ["DISCOUNT (#{document.discount_rate.to_i}%)", 
                   "- #{number_with_precision(document.discount)}"]
        end
        
        data << ["12% VAT", "#{number_with_precision(document.vat)}"]
        data << ["TOTAL", "PHP #{number_with_precision(document.total)}"]

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