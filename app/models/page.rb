class Page < ApplicationRecord
  include Destroyable
  validates :slug, :body, :name, presence: true

  scope :active, -> { where(active: true) }
end
