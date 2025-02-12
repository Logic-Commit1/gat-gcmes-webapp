module PdfGenerator
  class Quotation < Base
    def generate_specific
      # lines_table(@report.lines)
    end

    # def lines_table(lines)
    #   return if lines.empty?

    #   items_table_data = [
    #     ["Serial No", "Description", "Component", "Quantity", "Job Number", "Result"]
    #   ]

    #   lines.each do |line|
    #     items_table_data << [ 
    #       line[:serial_number], 
    #       (line[:equipment] unless line.family == "Child"), 
    #       line[:parts],
    #       line[:quantity],
    #       line[:job_number],
    #       set_color(line[:results])
    #     ]
    #   end

    #   @pdf.text "TEST ITEMS", size: font_size, align: :left, style: :bold

    #   data_table(items_table_data, 1)

    #   @pdf.move_down 5
    # end

    def specific_sub_header
      @pdf.text "Date Requested: #{@document.created_at.strftime("%B %d, %Y")}", align: :right
    end

    def products_table
      products = @document.deleted? ? @document.products.with_deleted : @document.products
      
      draw_products_header
      
      products.each_with_index do |product, index|
        draw_product_row(product, index)
        draw_specs_and_scopes(product)
        draw_product_image(product)
        @pdf.move_down 10
      end
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
            t.row(0).background_color = "DDDDDD"
            t.row(0).align = :center
            t.row(0).borders = [:bottom, :top, :left, :right]
            t.row(1).height = 55
            t.row(1).borders =  [:bottom, :top, :left, :right]
            t.row(1).padding = [1, 8, 0, 8]
            t.row(2).padding = [-20, 8, 8, 8]
            t.row(0).padding = 8
            t.cells.align = :center
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
      
      @pdf.table(data, width: @document_width) do |t|
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
    end

    def apply_column_widths(table)
      table.column(0).width = 30
      table.column(1).width = (@document_width) * 0.5
      table.column(2).width = 30
      table.column(3).width = 40
      table.columns(4).width = (@document_width) * 0.16
    end

  end
end
  