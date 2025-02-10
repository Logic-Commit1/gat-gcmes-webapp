module PdfGenerator
  class RequestForm < Base
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
  end
end
  