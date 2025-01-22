namespace :storage do
  desc 'Migrate ActiveStorage files from local to cloudflare'
  task migrate_to_cloudflare: :environment do
    User.find_each do |user|
      if user.signature.attached? && user.signature.service_name == "Disk"
        begin
          puts "Migrating signature for user #{user.id}"
          user.signature.open do |file|
            # Create a temporary blob with the same content but using cloudflare service
            new_blob = ActiveStorage::Blob.create_and_upload!(
              io: file,
              filename: user.signature.filename,
              content_type: user.signature.content_type,
              service_name: :cloudflare
            )
            # Update the attachment to point to the new blob
            user.signature.update!(blob_id: new_blob.id)
          end
          # Delete the old blob
          user.signature.blob.purge
        rescue => e
          puts "Error migrating signature for user #{user.id}: #{e.message}"
        end
      end
    end
  end
end 