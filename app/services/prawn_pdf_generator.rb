class PrawnPdfGenerator
    MANROPE_FONT_PATH = 'app/assets/fonts/Manrope/Manrope-Regular.ttf'
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
        totals_table(@document)
        terms_and_conditions(@document)
        # signatures(@document)
      end

      @path
    end

    private

    def setup_fonts
      @pdf.font_families.update(
        'manrope' => {
          normal: MANROPE_FONT_PATH,
          bold: MANROPE_BOLD_FONT_PATH
        }
      )
    end

    def header
      # Contact details section
      @pdf.bounding_box([0, @pdf.cursor], width: 260, height: 84) do
        # Fill background with orange gradient (closest approximation in PDF)
        @pdf.fill_color "fdae4e"
        @pdf.fill_rectangle [0, 84], 260, 84
        @pdf.fill_color "000000"

        # Contact details with padding
        # @pdf.font('manrope', size: 8) do
          @pdf.bounding_box([8, 76], width: 244, height: 76) do
            @pdf.text " #{@document.company.address}"
            @pdf.move_down 8
            @pdf.text " #{@document.company.contact_numbers.join(' | ')}"
            @pdf.move_down 8
            @pdf.text " #{@document.company.emails.join(', ')}"
          end
        # end
      end

      # Logo section
      @pdf.bounding_box([260, @pdf.cursor + 84], width: 145, height: 84) do
        # Navy blue background
        @pdf.fill_color "000a52"
        @pdf.fill_rectangle [0, 84], 145, 84
        @pdf.fill_color "000000"

        # Logo
        logo_y_position = 84 - ((84 - 50) / 2) # Center the 40px height logo
        @pdf.image GAT_LOGO_PATH, at: [34.5, logo_y_position], width: 76, height: 40

        # Company name
        # @pdf.font('manrope', size: 10, style: :bold) do
          @pdf.fill_color "f5db07"
          @pdf.text_box "GOLDEN ARROW TRADING",
            at: [0, 20],
            width: 145,
            align: :center
        # end
        @pdf.fill_color "000000"
      end

      # Document name and uid
      @pdf.bounding_box([420, @pdf.cursor + 84], width: 145, height: 84) do
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
      
      headers = [
        ["SN", "Description", "Qty", "U/M", "Unit Price", "Total Amount"]
      ]

      @pdf.table(headers, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F3F9FF"
        t.cells.padding = 8
        t.cells.borders = [:bottom, :top, :left, :right]
        t.column(0).width = 30
        t.column(1).width = (@document_width) * 0.3
        t.column(2).width = 60
        t.column(3).width = 60
        t.columns(2..6).align = :right
        t.columns(5..6).width = (@document_width) * 0.17
      end

      products.each_with_index do |p, index|
        # Product row
        data = [
          [index + 1, p.name, p.quantity, p.unit.upcase, 
           "PHP #{number_with_precision(p.price)}", 
           "PHP #{number_with_precision(p.total)}"]
        ]
        
        @pdf.table(data, width: @document_width, cell_style: {valign: :center}) do |t|
          t.cells.padding = 8
          t.cells.borders = [:bottom, :top, :left, :right]
          t.column(0).width = 30
          t.column(0).align = :center
          t.column(1).width = (@document_width) * 0.3
          t.column(1).align = :left
          t.column(2).width = 60
          t.column(3).width = 60
          t.columns(2..6).align = :right
          t.columns(5..6).width = (@document_width) * 0.17
        end

        # Specs and Scope row
        specs = p.deleted? ? p.specs.with_deleted : p.specs
        scopes = p.deleted? ? p.scopes.with_deleted : p.scopes

        if specs.any? || scopes.any?
          specs_and_scope_content = ""
          
          if specs.any?
            specs_and_scope_content += "SPECS:\n"
            specs.each do |spec|
              specs_and_scope_content += "#{spec.name} : #{spec.value}\n"
            end
          end

          if specs.any? && scopes.any?
            specs_and_scope_content += "\n"
          end

          if scopes.any?
            specs_and_scope_content += "SCOPE OF WORK:\n"
            scopes.each do |scope|
              specs_and_scope_content += "* #{scope.name}\n"
            end
          end

          @pdf.table([[nil, specs_and_scope_content, "", "", "", "", ""]], 
                    width: @document_width) do |t|
            t.cells.padding = 8
            t.cells.borders = []
            t.column(1).borders = [:bottom, :top, :left, :right]
            t.column(0).width = 30
            t.column(1).width = (@document_width) * 0.3
            t.column(2).width = (@document_width) * 0.1
            t.columns(5..6).width = (@document_width) * 0.17
          end
        end

        # Product image row
        if p.image.attached?
          begin
            image_data = p.image.download
            image_path = "tmp/product_image_#{p.id}.jpg"
            File.binwrite(image_path, image_data)
            
            @pdf.table([[nil, { image: image_path, position: :center, fit: [100, 100] }, 
                        "", "", "", "", ""]], 
                      width: @document_width) do |t|
              t.cells.padding = 8
              t.cells.borders = []
              t.column(1).borders = [:bottom, :top, :left, :right]
              t.column(0).width = 30
              t.column(1).width = (@document_width) * 0.3
              t.column(2).width = (@document_width) * 0.1
              t.columns(5..6).width = (@document_width) * 0.17
            end
            
            File.delete(image_path) if File.exist?(image_path)
          rescue ActiveStorage::FileNotFoundError
            p.image.purge if p.image.attached?
          end
        end

        # Spacer row
        @pdf.move_down 10
      end
    end

    def totals_table(document)
      @pdf.bounding_box([@document_width - 220, @pdf.cursor], width: 200) do
        data = [["SUB TOTAL", "PHP #{number_with_precision(document.sub_total)}"]]
        
        if document.discount > 0
          data << ["DISCOUNT (#{document.discount_rate.to_i}%)", 
                   "- #{number_with_precision(document.discount)}"]
        end
        
        data << ["12% VAT", "PHP #{number_with_precision(document.vat)}"]
        data << ["TOTAL", "PHP #{number_with_precision(document.total)}"]

        @pdf.table(data, width: 200) do |t|
          t.cells.padding = [2, 8]
          t.cells.borders = []
          t.column(1).align = :right
          # t.cell[4..5].borders = [:bottom]
          t.row(-1).background_color = "F8D251"
          t.row(-1).text_color = "D60000"
          t.row(-1).font_style = :bold
        end
      end
      @pdf.move_down 20
    end

    def terms_and_conditions(document)
      @pdf.move_down 40
      @pdf.text "TERMS AND CONDITIONS", style: :bold
      # @pdf.move_down 10

      terms = []
      terms << ["Lead time", document.lead_time] if document.lead_time.present?
      terms << ["Duration", document.duration] if document.duration.present?
      terms << ["Warranty", document.warranty] if document.warranty.present?
      terms << ["Payment", document.payment] if document.payment.present?

      @pdf.table(terms, width: 500) do |t|
        t.cells.padding = 8
        t.cells.borders = []
        t.column(0).font_style = :bold
        t.column(0).width = 70
      end
    end

    def signatures(document)
      @pdf.move_down 20
      @pdf.text "For further information please don't hesitate to contact us", align: :center
      @pdf.move_down 20

      data = [
        ["Conforme by", "Prepared by", "Approved by"],
        ["", "", ""]
      ]

      # Add signature images and names
      if document.user&.signature&.attached?
        begin
          signature_data = document.user.signature.download
          signature_path = "tmp/signature_#{document.user.id}.jpg"
          File.binwrite(signature_path, signature_data)
          data[1][1] = { 
            image: signature_path,
            fit: [100, 35],
            position: :center
          }
          File.delete(signature_path) if File.exist?(signature_path)
        rescue ActiveStorage::FileNotFoundError
          document.user.signature.purge
        end
      end

      if document.approved? && document.approver&.signature&.attached?
        begin
          approver_signature_data = document.approver.signature.download
          approver_signature_path = "tmp/signature_#{document.approver.id}.jpg"
          File.binwrite(approver_signature_path, approver_signature_data)
          data[1][2] = { 
            image: approver_signature_path,
            fit: [100, 35],
            position: :center
          }
          File.delete(approver_signature_path) if File.exist?(approver_signature_path)
        rescue ActiveStorage::FileNotFoundError
          document.approver.signature.purge
        end
      end

      @pdf.table(data, width: @document_width) do |t|
        t.row(0).font_style = :bold
        t.row(0).align = :center
        t.row(1).height = 50
        t.cells.padding = 8
        t.cells.borders = []
      end

      # Add names under signatures
      names_data = [
        ["", 
         "#{document.user&.first_name&.titleize} #{document.user&.last_name&.titleize}",
         document.approved? ? document.approver&.full_name : ""]
      ]

      @pdf.table(names_data, width: @document_width) do |t|
        t.cells.align = :center
        t.cells.padding = [0, 8, 8, 8]
        t.cells.borders = []
      end
    end

    def number_with_precision(number, precision: 2, delimiter: ',')
      whole, decimal = number.to_s.split('.')
      whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(delimiter).reverse
      [whole_with_commas, decimal&.ljust(precision, '0')].compact.join('.')
    end
end