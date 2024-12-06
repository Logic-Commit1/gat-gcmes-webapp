Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '1cm',
      bottom: '1cm',
      left: '1cm',
      right: '1cm'
    },
    prefer_css_page_size: true,
    print_background: true,
    emulate_media: 'screen',
    wait_until: 'networkidle0',
    viewport: {
      width: 794,  # A4 width in pixels at 96 DPI
      height: 1123 # A4 height in pixels at 96 DPI
    }
  }
end