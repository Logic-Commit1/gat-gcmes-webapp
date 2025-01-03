class Client < ApplicationRecord
    belongs_to :company
    has_many :quotations
    has_many :projects
    has_many :contacts, as: :contactable, dependent: :destroy

    accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank
    before_validation :process_arrays

    scope :latest_first, -> { order(created_at: :desc) }

    private

    def process_arrays
        # Convert comma-separated strings to arrays
        contacts.each do |contact|
            if contact.emails.is_a?(String)
                contact.emails = contact.emails.split(',').map(&:strip)
            end
        
            if contact.contact_numbers.is_a?(String)
                contact.contact_numbers = contact.contact_numbers.split(',').map(&:strip)
            end
        end
    end

end
