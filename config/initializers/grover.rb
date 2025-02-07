Grover.configure do |config|
  config.options = {
    executable_path: Rails.env.production? ? '/opt/render/project/src/chrome/linux-131.0.6778.87/chrome-linux64/chrome' : '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
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
    wait_until: 'domcontentloaded',
    viewport: {
      width: 794,  # A4 width in pixels at 96 DPI
      height: 1123 # A4 height in pixels at 96 DPI
    },
    cache: true,
    scale: 1,
    timeout: 10_000,
    launch_args: [
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--disable-web-security',
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-extensions',
      '--disable-software-rasterizer',
      '--headless'
    ]
  }
  config.use_png_middleware = false
  config.use_jpeg_middleware = false
  config.use_pdf_middleware = false

  # Set environment-specific root URL
  config.root_url = Rails.env.production? ? 'https://goldenchain.onrender.com' : 'http://localhost:3000'
  
end
