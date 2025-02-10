module PdfGenerator
  module StylingDefaults
    # def header_column_widths
    #   [258, 258, 258]
    # end

    # def general_params_column_widths
    #   [140, 247, 140, 247]
    # end
    
    # def specifc_params_column_widths
    #   [62, 93, 62, 93, 62, 93, 62, 93, 62, 93]
    # end

    # def table_width
    #   776
    # end
    
    def default_padding
      [1, 2, 4, 2]
    end
    
    # def shaded_cell_color
    #   "efefef"
    # end

    def font_size
      # 6.5
      8
    end

    def align
      :center
    end

    def valign
      :center
    end
  end
end