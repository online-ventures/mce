class Model < ActiveRecord::Base
  attr_accessible :make_id, :name
  belongs_to :make

  def self.fetch(id)
    Rails.cache.fetch("Model/#{id}"){ Model.find(id) }
  end
end
