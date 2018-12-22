class Purchase < ApplicationRecord
  belongs_to :subscriber
  belongs_to :vehicle

  validates :price, presence: true, numericality: true
  validates :profit, numericality: true, if: :profit?
end
