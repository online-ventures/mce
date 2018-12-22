class Page < ApplicationRecord
  acts_as_paranoid
  validates :slug, :body, :name, presence: true

  scope :public, -> { where(active: true) }

  def restore
    self.deleted_at = nil
    save!
  end
end
