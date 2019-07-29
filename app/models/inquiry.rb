class Inquiry < ApplicationRecord
  # Relationships
  belongs_to :subscriber
  belongs_to :vehicle

  # Validations
  validates :body, presence: true

  def no_error?
    error == ''
  end
end
