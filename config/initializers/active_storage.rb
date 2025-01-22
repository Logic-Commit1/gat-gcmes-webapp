Rails.application.configure do
  config.after_initialize do
    ActiveStorage::Current.url_options = {
      host: 'goldenchain.onrender.com',
      protocol: 'https'
    }
  end
end