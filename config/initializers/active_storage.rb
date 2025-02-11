if Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      ActiveStorage::Current.url_options = {
        host: 'goldenchain.onrender.com',
        protocol: 'https'
      }
    end
  end
else
  Rails.application.configure do
    config.after_initialize do
      ActiveStorage::Current.url_options = {
        host: 'localhost:3000',
        protocol: 'http'
      }
    end
  end
end
