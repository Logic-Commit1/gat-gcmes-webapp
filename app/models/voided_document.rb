class VoidedDocument < ApplicationRecord
  # belongs_to :document, polymorphic: true

  scope :search_by_term, ->(term) { 
    joins(:document).where(
      "voided_documents.name ILIKE :term OR voided_documents.code ILIKE :term", 
      term: "%#{term}%"
    ) 
  }

  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(voided_documents.created_at) = ?", Date.parse(date))
  }
end
