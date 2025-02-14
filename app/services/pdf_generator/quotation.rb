module PdfGenerator
  class Quotation < Base

    def specific_sub_header
      @pdf.text "<b>Date Requested:</b> #{@document.created_at.strftime("%B %d, %Y")}", align: :right, inline_format: true
      @pdf.move_down 5
    end

    def client_details
      data = [
        [{content: "Client Details", colspan: 2}],
        ["Company Name", @document.client.name],
        ["Business Address", @document.client.address],
        ["Attention", @document.attention&.titleize],
        ["Vessel", @document.vessel&.upcase]
      ]

      @pdf.bounding_box([0, @pdf.cursor], width: @document_width) do
        @pdf.table(data, width: @document_width) do |t|
          t.row(0).font_style = :bold
          t.row(0).align = :center
          t.row(0).background_color = "F3F9FF"
          t.cells.padding = 7
          t.cells.borders = [:bottom, :top, :left, :right]
          t.cells.border_width = 0.5
          t.column(0).width = @document_width * 0.2
        end
      end
      
      @pdf.move_down 10

      subject_line
    end

    def subject_line
      @pdf.text "Subject: #{@document.subject}", style: :bold
      @pdf.move_down 5
    end

    def products_table
      products = @document.deleted? ? @document.products.with_deleted : @document.products
      
      draw_products_header
      
      products.each_with_index do |product, index|
        # Calculate total height needed for this product row
        required_height = calculate_product_row_height(product)
        
        # Check if we need to move to next page (adding some padding)
        if @pdf.cursor < (required_height + 20)
          @pdf.start_new_page
          draw_products_header
        end
        
        draw_product_row(product, index)
        @pdf.move_down 10
      end
    end

    def totals_table
      # Position the table at the right side by calculating offset from right margin
      table_width = 180
      x_position = @document_width - table_width + 20
      
      @pdf.bounding_box([x_position, @pdf.cursor], width: table_width) do
        data = [["SUB TOTAL", "PHP #{number_with_precision(@document.sub_total)}"]]
        
        if @document.discount > 0
          data << ["DISCOUNT (#{@document.discount_rate.to_i}%)", 
                  "- #{number_with_precision(@document.discount)}"]
        end
        
        data << ["12% VAT", "#{number_with_precision(@document.vat)}"]
        data << ["TOTAL", "PHP #{number_with_precision(@document.total)}"]

        @pdf.table(data, width: table_width - 20) do |t|
          t.cells.padding = [2, 7]
          t.cells.borders = []
          t.cells.font_style = :semi_bold
          t.column(1).align = :right
          t.row(-1).borders = [:top] # Add top border to last row
          t.row(-1).background_color = "F8D251"
          t.row(-1).text_color = "D60000"
        end
      end

      @pdf.move_down 10
    end

    def terms_and_conditions
      @pdf.text "TERMS AND CONDITIONS", style: :bold
      @pdf.move_down 5

      terms = []
      terms << ["Lead time", @document.lead_time] if @document.lead_time.present?
      terms << ["Duration", @document.duration] if @document.duration.present?
      terms << ["Warranty", @document.warranty] if @document.warranty.present?
      terms << ["Payment", @document.payment.present? ? @document.payment : "n/a"]

      @pdf.table(terms, width: @document_width) do |t|
        t.cells.borders = []
        t.cells.padding = [2, 0]
        # t.cells.borders = []
        t.column(0).font_style = :semi_bold
        t.column(0).width = 55
        # t.column(0).padding_left = 0
        # t.column(0).align = :left
      end

      @pdf.move_down 10
    end

    def signatures_table
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
      if @document.user&.signature&.attached?
        signature_from_object = @document.user.signature
        signature = StringIO.open(signature_from_object.download)
        data[1][1] = { image: signature, position: :center, fit: [100, 40] }
        data[2][1] = "#{@document.user&.first_name&.titleize} #{@document.user&.last_name&.titleize}"
      end

      # Handle approver signature (Approved by - right column)
      if @document.approved? && @document.approver&.signature&.attached?
        approver_signature_from_object = @document.approver.signature
        approver_signature = StringIO.open(approver_signature_from_object.download)

        data[1][2] = { image: approver_signature, position: :center, fit: [100, 45] }
        data[2][2] = "#{@document.approver&.first_name&.titleize} #{@document.approver&.last_name&.titleize}"
      end
      
      # Draw the table with styling
      begin
        @pdf.bounding_box([0, @pdf.cursor], width: @document_width) do
          @pdf.table(data, width: @document_width) do |t|
            t.row(0).font_style = :bold
            t.row(0).background_color = "F3F9FF"
            t.row(0).align = :center
            t.row(0).borders = [:bottom, :top, :left, :right]
            t.row(1).height = 55
            t.row(1).borders =  [:bottom, :top, :left, :right]
            t.row(1).padding = [1, 8, 0, 8]
            t.row(2).padding = [-20, 8, 8, 8]
            t.row(0).padding = 8
            t.cells.align = :center
            t.cells.border_width = 0.5
          end
        end
      rescue => e
        puts "Error generating signatures table:"
        puts e.message
        puts e.backtrace
        raise e
      end
    end

    private

    def draw_products_header
      headers = [["SN", "Description", "Qty", "U/M", "Unit Price", "Total Amount"]]

      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 7
        t.cells.border_width = 0.5
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
        t.columns(2..6).align = :right
        t.column(0).align = :center
      end
    end

    def draw_product_row(product, index)
      data = [
        [index + 1, product.name, product.quantity, product.unit.upcase, 
        "PHP #{number_with_precision(product.price)}", 
        "PHP #{number_with_precision(product.total)}"]
      ]
      
      @pdf.table(data, width: @document_width) do |t|
        t.cells.padding = 7
        t.cells.borders = [:bottom, :top, :left, :right]
        t.cells.border_width = 0.5
        apply_column_widths(t)
        t.column(0).align = :center
        t.column(1).align = :left
        t.columns(2..6).align = :right
      end

      draw_specs_and_scopes(product)
    end

    def draw_specs_and_scopes(product)
      specs = product.deleted? ? product.specs.with_deleted : product.specs
      scopes = product.deleted? ? product.scopes.with_deleted : product.scopes

      return unless specs.any? || scopes.any?

      content = build_specs_and_scopes_content(specs, scopes)
      
      @pdf.table([[nil, content, "", "", "", "", ""]], width: @document_width) do |t|
        t.cells.padding = 7
        t.cells.border_width = 0.5
        t.cells.borders = []
        t.column(1).borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
      end

      draw_product_image(product)

    end

    def draw_product_image(product)
      return unless product.image.attached?
        image_data = product.image.download
        image_path = "tmp/product_image_#{product.id}.jpg"
        File.binwrite(image_path, image_data)
        
        @pdf.table([[nil, { image: image_path, position: :left, fit: [100, 100] }, 
                    "", "", "", "", ""]], width: @document_width) do |t|
          t.cells.padding = 7
          t.cells.borders = []
          t.column(1).borders = [:bottom, :left, :right]
          apply_column_widths(t)
        end
        
        File.delete(image_path) if File.exist?(image_path)
    end

    def apply_column_widths(table)
      table.column(0).width = 30
      table.column(1).width = (@document_width) * 0.5
      table.column(2).width = 30
      table.column(3).width = 40
      table.columns(4).width = (@document_width) * 0.16
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

    def calculate_product_row_height(product)
      total_height = 0
      
      # Height for main product row (using cell padding of 7)
      total_height += 14 # Basic cell padding (7 * 2)
      
      # Calculate height for specs and scopes if present
      specs = product.deleted? ? product.specs.with_deleted : product.specs
      scopes = product.deleted? ? product.scopes.with_deleted : product.scopes
      
      if specs.any? || scopes.any?
        content = build_specs_and_scopes_content(specs, scopes)
        # Calculate height of text box with content
        text_height = @pdf.height_of(content, width: @document_width * 0.5)
        total_height += text_height + 14 # Add cell padding
      end
      
      # Add height for product image if present
      if product.image.attached?
        total_height += 114 # Image height (100) + cell padding (14)
      end
      
      total_height
    end

  end
end
  