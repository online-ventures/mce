class BodyType < ActiveRecord::Base
  attr_accessible :name
  has_many :vehicles

  def to_s
    name
  end
end
