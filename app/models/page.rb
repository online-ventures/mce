class Page < ActiveRecord::Base
  attr_accessible :active, :body, :featured, :name, :slug
  validates :slug, :body, :name, presence: true

  scope :public, where(active: true)
end
