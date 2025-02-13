module PdfGenerator
  class Canvass < Base
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
      @pdf.text "<b>Description:</b> #{@document.description}", align: :left, inline_format: true
      @pdf.move_down 2
      @pdf.text "<b>Quantity:</b> #{@document.quantity} #{@document.unit}", align: :left, inline_format: true
      @pdf.move_down 5
      # @pdf.text "Date Requested: #{@document.created_at.strftime("%B %d, %Y")}", align: :right
    end

    def products_table
      products = @document.deleted? ? @document.products.with_deleted : @document.suppliers
      
      draw_products_header

      products.each do |product_info|
        product_info.each do |description, suppliers|
          suppliers.each do |supplier_info|
            supplier_info.each do |supplier_name, details|
              draw_product_row(supplier_name, details)
            end
          end
        end
        @pdf.move_down 20
      end
    end

    def signatures_table
      # @pdf.move_down 20
      
      # Initialize base data structure with headers and empty cells
      data = [
        ["Requested by", "Approved by"],
        ["", ""],
        ["", ""]
      ]

      # Handle user signature (Requested by - left column)
      begin
        if @document.user&.signature&.attached?
          signature_from_object = @document.user.signature
          signature = StringIO.open(signature_from_object.download)
          data[1][0] = { image: signature, position: :center, fit: [100, 40] }
          data[2][0] = @document.user ? "#{@document.user.first_name&.titleize} #{@document.user.last_name&.titleize}" : ""
        end
      rescue ActiveStorage::FileNotFoundError => e
        Rails.logger.error "Error loading user signature: #{e.message}"
        @document.user.signature.purge if @document.user.signature.attached?
      end

      # Handle approver signature (Approved by - right column)
      begin
        if @document.approved? && @document.approver&.signature&.attached?
          approver_signature_from_object = @document.approver.signature
          approver_signature = StringIO.open(approver_signature_from_object.download)
          data[1][1] = { image: approver_signature, position: :center, fit: [100, 40] }
          data[2][1] = @document.approver ? "#{@document.approver.first_name&.titleize} #{@document.approver.last_name&.titleize}" : ""
        end
      rescue ActiveStorage::FileNotFoundError => e
        Rails.logger.error "Error loading approver signature: #{e.message}"
        @document.approver.signature.purge if @document.approver.signature.attached?
      end

      @pdf.table(data, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.row(0).align = :center
        t.row(0).borders = [:bottom, :top, :left, :right]
        t.row(1).height = 55
        t.row(1).borders = [:left, :right]
        t.row(1).padding = [1, 8, 0, 8]
        t.row(2).padding = [-20, 8, 8, 8]
        t.row(0).padding = 8
        t.cells.align = :center
        t.cells.border_width = 0.5
      end
    end

    private

    def draw_products_header
      headers = [["Supplier Name", "Price", "Brand", "Terms", "Remarks"]]

      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
        t.columns(1..4).align = :right
        t.cells.border_width = 0.5
        # t.column(4).align = :left
      end
    end

    def draw_product_row(supplier_name, details)
      data = [
        [supplier_name, "PHP #{number_with_precision(details[0].to_f, precision: 2, delimiter: ',')}", details[1], details[2], details[3]]
      ]
      
      @pdf.table(data, width: @document_width) do |t|
        t.cells.padding = 8
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_column_widths(t)
        t.column(0).align = :left
        t.columns(1..4).align = :right
        
        # Apply styling for selected supplier

        if details[4]  # If supplier is selected
          t.cells.background_color = "FFFAE4"  # Light yellow background
          t.cells.border_width = 0.5
          
          # Apply orange color only to outer borders
          t.cells.each_with_index do |cell, i|
            if i == 0  # First cell
              cell.border_left_color = "FFBE6A"
              cell.border_left_width = 2
            end
            if i == 4  # Last cell
              cell.border_right_color = "FFBE6A"
              cell.border_right_width = 2
            end
            cell.border_top_color = "FFBE6A"
            cell.border_bottom_color = "FFBE6A"
            cell.border_top_width = 2
            cell.border_bottom_width = 2
          end
        else
          t.cells.borders = [:bottom, :left, :right] 
          t.cells.border_color = "000000"
          t.cells.border_width = 0.5
        end
      end
    end
    
    def apply_column_widths(table)
      # Calculate widths as percentages of total document width
      table.column(0).width = @document_width * 0.46 
      table.column(1).width = @document_width * 0.17
      table.column(2).width = @document_width * 0.13
      table.column(3).width = @document_width * 0.12
      table.column(4).width = @document_width * 0.12
    end
  end
end
  