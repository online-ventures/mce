class Page < ActiveRecord::Base
  attr_accessible :active, :body, :featured, :name, :slug
end
