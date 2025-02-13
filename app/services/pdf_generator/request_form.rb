module PdfGenerator
  class RequestForm < Base
    def products_table
      project_details
      if @document.Allowance?
        allowance_table
      else
        order_table
      end
    end

    def specific_sub_header
      # @pdf.text "Date Requested: #{@document.created_at.strftime("%B %d, %Y")}", align: :right
    end

    private

    def project_details
      @pdf.table([
        [
          { content: "<b>Project:</b> #{@document.project.uid}", borders: [], inline_format: true, padding: 0 },
          { content: "<b>Date Requested:</b> #{@document.created_at.strftime("%B %d, %Y")}", borders: [], inline_format: true, align: :right, padding: 0 }
        ]
      ], width: @document_width)

      @pdf.move_down 6
    end

    def travel_details
      @pdf.move_down 8

      if @document.start_travel_date.present? && @document.end_travel_date.present?
        travel_date = "#{@document.start_travel_date.strftime("%B %d")} to #{@document.end_travel_date.strftime("%B %d")}"
        

        # @pdf.table([
        #   [
        #     { content: "<b>Travel Date:</b> #{travel_date}", borders: [], inline_format: true, padding: 0 },
        #     { content: "<b>Destination:</b> #{@document.destination}", borders: [], inline_format: true, padding: 0 },
        #     { content: "<b>Vehicle:</b> #{@document.vehicle}", borders: [], inline_format: true, padding: 0 }
        #   ]
        # ], width: @document_width)
        @pdf.text "<b>Travel Date:</b> #{travel_date}", align: :left, inline_format: true
        @pdf.move_down 5
        @pdf.text "<b>Destination:</b> #{@document.destination}", align: :left, inline_format: true
        @pdf.move_down 5
        @pdf.text "<b>Vehicle:</b> #{@document.vehicle}", align: :left, inline_format: true
      end

      if @document.Allowance?
        balance_table
      end
    end

    def allowance_table
      headers = [["SN", "Particulars", "Estimate Allowance", "Remarks"]]
      
      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.border_width = 0.5
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_allowance_column_widths(t)
        t.column(2).align = :right
      end

      @document.particulars.each_with_index do |p, index|
        data = [
          [index + 1, 
           p.name, 
           "#{index == 0 ? 'PHP' : ''} #{number_with_precision(p.allowance, precision: 2, delimiter: ',')}",
           ""]
        ]
        
        @pdf.table(data, width: @document_width) do |t|
          t.cells.padding = 8
          t.cells.border_width = 0.5
          t.cells.borders = [:bottom, :top, :left, :right]
          apply_allowance_column_widths(t)
          t.column(0).align = :center
          t.column(2).align = :right
        end
      end

      # Total row
      @pdf.table([
        ["", "Total", "PHP #{number_with_precision(@document.total, precision: 2, delimiter: ',')}", ""]
      ], width: @document_width) do |t|
        t.cells.padding = 8
        t.cells.border_width = 0.5
        apply_allowance_column_widths(t)
        t.column(2).align = :right
        t.columns([3]).borders = []
      end

      if @document.Allowance?
        travel_details
      end

      
    end

    def balance_table
      headers = [
        ["Remarks", "Fuel Gauge", "Easy Trip Balance", "Sweep Balance"]
      ]

      @pdf.move_down 10
      @pdf.table(headers + [[
        @document.remarks,
        @document.fuel_gauge ? "PHP #{number_with_precision(@document.fuel_gauge, precision: 2, delimiter: ',')}" : "",
        @document.easy_trip_balance ? "PHP #{number_with_precision(@document.easy_trip_balance, precision: 2, delimiter: ',')}" : "",
        @document.sweep_balance ? "PHP #{number_with_precision(@document.sweep_balance, precision: 2, delimiter: ',')}" : ""
      ]], width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.border_width = 0.5
        t.cells.borders = [:bottom, :top, :left, :right]
        t.columns(1..3).align = :right
      end
    end

    def order_table
      headers = [["SN", "Item", "Quantity", "U/M", "Unit Price", "Estimated Amount"]]
      
      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.border_width = 0.5
        t.cells.borders = [:bottom, :top, :left, :right]
        apply_order_column_widths(t)
        t.column(2..5).align = :right
      end

      @document.products.each_with_index do |p, index|
        data = [
          [index + 1,
           p.description,
           p.quantity,
           p.unit,
           "#{index == 0 ? 'PHP' : ''} #{number_with_precision(p.price, precision: 2, delimiter: ',')}",
           "#{index == 0 ? 'PHP' : ''} #{number_with_precision(p.total, precision: 2, delimiter: ',')}"]
        ]
        
        @pdf.table(data, width: @document_width) do |t|
          t.cells.padding = 8
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
        t.cells.padding = 8
        t.cells.border_width = 0.5
        apply_order_column_widths(t)
        t.column(4..5).align = :right
        t.columns(0..3).borders = []
      end
    end

    def signatures_table
      @pdf.move_down 20
      
      data = @document.Allowance? ? 
        [["Requested by", "Checked by", "Pre-approved by", "Approved by"], ["", "", "", ""], ["", "", "", ""]] :
        [["Requested by", "Checked by", "Procurement", "Pre-approved by", "Approved by"], ["", "", "", "", ""], ["", "", "", "", ""]]

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
        t.row(0).background_color = "DDDDDD"
        t.cells.align = :center
        t.cells.padding = 8
        t.cells.border_width = 0.5
        t.row(1).height = 55
        t.row(1).padding = [1, 8, 0, 8]
        t.row(2).padding = [-20, 8, 8, 8]
        apply_signatures_column_widths(t)
      end
    end

    def apply_signatures_column_widths(table)
      total_width = @document_width
      
      column_count = @document.Allowance? ? 4 : 5
      width_percentage = 1.0 / column_count
      
      column_count.times do |i|
        table.column(i).width = total_width * width_percentage
      end
    end

    def apply_allowance_column_widths(table)
      total_width = @document_width  # Subtract 1 to ensure we're within bounds
      
      table.column(0).width = total_width * 0.05  # SN
      table.column(1).width = total_width * 0.40  # Particulars
      table.column(2).width = total_width * 0.20  # Estimate Allowance
      table.column(3).width = total_width * 0.35  # Remarks
    end

    def apply_order_column_widths(table)
      total_width = @document_width  # Subtract 1 to ensure we're within bounds
      
      table.column(0).width = total_width * 0.05  # SN
      table.column(1).width = total_width * 0.35  # Item
      table.column(2).width = total_width * 0.10  # Quantity
      table.column(3).width = total_width * 0.10  # U/M
      table.column(4).width = total_width * 0.20  # Unit Price
      table.column(5).width = total_width * 0.20  # Estimated Amount
    end
  end
end
  