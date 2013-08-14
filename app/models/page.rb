class Page < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :active, :body, :featured, :name, :slug
  validates :slug, :body, :name, presence: true

  scope :public, where(active: true)

  def restore
    self.deleted_at = nil
    save!
  end
end
