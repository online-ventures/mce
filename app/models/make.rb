class Make < ActiveRecord::Base
  attr_accessible :name
  has_many :models

  def self.fetch(id)
    Rails.cache.fetch("Make/#{id}"){ Make.find(id) }
  end
end
