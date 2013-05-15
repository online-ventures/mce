class Page < ActiveRecord::Base
  attr_accessible :active, :body, :name, :slug
end
