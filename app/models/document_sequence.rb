class DocumentSequence < ApplicationRecord
  validates :document_type, presence: true
  validates :company_code, presence: true
  validates :year, presence: true
  validates :last_sequence, presence: true

  def self.next_sequence(document_type, company_code)
    year = Time.current.year
    sequence = find_or_create_by(document_type: document_type, company_code: company_code, year: year) do |seq|
      seq.last_sequence = 0
    end
    
    sequence.increment!(:last_sequence)
    sequence.last_sequence
  end
end 