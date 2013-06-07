class Page < ActiveRecord::Base
  attr_accessible :active, :body, :featured, :name, :slug

  scope :public, where(active: true)
end
