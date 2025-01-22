Rails.application.config.to_prepare do
    ActiveStorage::Blob.class_eval do
      before_create do
        if service_name.to_s == "cloudflare"
          self.checksum = nil
          self.metadata["checksum"] = nil if self.metadata.is_a?(Hash)
        end
      end
    end
  end
  