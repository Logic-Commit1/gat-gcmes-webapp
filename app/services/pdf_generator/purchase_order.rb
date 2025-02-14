module PdfGenerator
  class PurchaseOrder < Base

    def specific_sub_header
      @pdf.table([
        [
          { content: "<b>Project:</b> #{@document.project.uid}", borders: [], inline_format: true, padding: 0 },
          { content: "<b>Date:</b> #{@document.created_at.strftime("%B %d, %Y")}", borders: [], inline_format: true, align: :right, padding: 0 }
        ]
      ], width: @document_width)

      @pdf.move_down 5

      supplier_details
    end

    def supplier_details
      data = [
        [{content: "Supplier Details", colspan: 2}],
        ["Company Name", @document.supplier.name],
        ["Business Address", @document.supplier.address],
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
      
      @pdf.move_down 15

      terms
    end

    def terms
      @pdf.text "<b>Terms:</b> #{@document.terms}", inline_format: true
    end



    def products_table
      headers = [["SN", "Subject Description", "Quantity", "U/M", "Unit Price", "Estimated Amount"]]
      
      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.column(0).align = :center
        t.cells.padding = 7
        t.cells.border_width = 0.5
        t.cells.borders = [:bottom, :top, :left, :right]
        t.column(2..5).align = :right
        apply_order_column_widths(t)
      end

      @document.products.each_with_index do |p, index|
        data = [
          [index + 1,
           p.name,
           p.quantity,
           p.unit,
           "#{index == 0 ? 'PHP' : ''} #{number_with_precision(p.price, precision: 2, delimiter: ',')}",
           "#{index == 0 ? 'PHP' : ''} #{number_with_precision(p.total, precision: 2, delimiter: ',')}"]
        ]
        
        @pdf.table(data, width: @document_width) do |t|
          t.cells.padding = 7
          t.cells.border_width = 0.5
          t.cells.borders = [:bottom, :top, :left, :right]
          apply_order_column_widths(t)
          t.column(0).align = :center
          t.columns(2..5).align = :right
        end
      end

      # Total row
      @pdf.table([
        ["", "", "", "", "Total", "PHP #{number_with_precision(@document.total, precision: 2, delimiter: ',')}"]
      ], width: @document_width) do |t|
        t.cells.padding = 7
        t.cells.border_width = 0.5
        apply_order_column_widths(t)
        t.column(4..5).align = :right
        t.columns(0..3).borders = []
      end

      @pdf.move_down 20
    end

    def signatures_table
      data = [["Requested by", "Checked by", "Pre-approved by", "Approved by"], ["", "", "", ""], ["", "", "", ""]]
        

      if @document.user&.signature&.attached?
        signature = StringIO.open(@document.user.signature.download)
        data[1][0] = { image: signature, position: :center, fit: [100, 40] }
        data[2][0] = @document.created_by
      end

      if @document.approved? && @document.approver&.signature&.attached?
        approver_signature = StringIO.open(@document.approver.signature.download)
        data[1][-1] = { image: approver_signature, position: :center, fit: [100, 40] }
        data[2][-1] = @document.approver&.full_name
      end


      @pdf.table(data, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.align = :center
        t.cells.padding = 7
        t.cells.border_width = 0.5
        t.row(1).height = 55
        t.row(1).padding = [1, 8, 0, 8]
        t.row(2).padding = [-20, 8, 8, 8]
        apply_signatures_column_widths(t)
      end

      @pdf.move_down 10

      conforme
    end

    def conforme
      @pdf.text "Conforme:"
      
      @pdf.stroke_horizontal_line 0, @document_width/2, at: @pdf.cursor - 15

      @pdf.move_down 10

      @pdf.text_box "Vendor shall confirm this order by signing CONFORME and dating it as proof of acceptance. In case of any breach of this order, GAT shall have the right to cancel the order by providing a written notice to the Vendor, without prejudice GAT's right to claim for damages, if any. An unexcused delay by the Vendor in the performance of its obligation or in the delivery of the goods shall cause termination of this order for default.", 
        width: @document_width * 0.8,
        align: :center,
        at: [@document_width * 0.1, @pdf.cursor - 20]
    end

    def apply_signatures_column_widths(table)
      total_width = @document_width
      column_count = 4
      
      width_percentage = 1.0 / column_count
      
      column_count.times do |i|
        table.column(i).width = total_width * width_percentage
      end
    end
      

    def apply_order_column_widths(table)
      total_width = @document_width
      
      table.column(0).width = total_width * 0.05  # SN
      table.column(1).width = total_width * 0.35  # Item
      table.column(2).width = total_width * 0.10  # Quantity
      table.column(3).width = total_width * 0.10  # U/M
      table.column(4).width = total_width * 0.20  # Unit Price
      table.column(5).width = total_width * 0.20  # Estimated Amount
    end
  end
end
  