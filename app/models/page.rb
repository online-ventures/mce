class Page < ApplicationRecord
  acts_as_paranoid
  validates :slug, :body, :name, presence: true

  scope :active, -> { where(active: true) }

  def restore
    self.deleted_at = nil
    save!
  end
end
