Grover.configure do |config|
  config.options = {
    # executable_path: Gem.loaded_specs['puppeteer-ruby'].full_gem_path + "/lib/puppeteer-ruby/puppeteer/.local-chromium/linux-xxxx/chrome-linux/chrome"
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
  config.use_png_middleware = true
  config.use_jpeg_middleware = true
  config.use_pdf_middleware = false

  # Set environment-specific root URL
  config.root_url = Rails.env.production? ? 'https://goldenchain.onrender.com' : 'http://localhost:3000'
  
  if Rails.env.production?
    config.options.merge!({
      launch_args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
      executable_path: `which chrome`.strip
    })
  end
end