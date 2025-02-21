class Client < ApplicationRecord
    belongs_to :company
    has_many :quotations
    has_many :projects
    has_many :contacts, as: :contactable, dependent: :destroy

    accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank
    before_validation :process_arrays

    scope :latest_first, -> { order(created_at: :desc) }
    scope :search_by_term, ->(term) { 
        joins(:contacts, :company).where(
          "clients.name ILIKE :term OR clients.code ILIKE :term OR
          clients.address ILIKE :term OR companies.name ILIKE :term OR companies.code ILIKE :term",
          term: "%#{term}%"
        ) 
      }

    scope :created_on_date, ->(date) {
      return all unless date.present?
      where("DATE(clients.created_at) = ?", Date.parse(date))
    }

    private

    def process_arrays
        # Convert comma-separated strings to arrays
        if contacts.present?
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

end
