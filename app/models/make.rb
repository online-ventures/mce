class Make < ActiveRecord::Base
  attr_accessible :name
  has_many :models

  def to_s
    name
  end
end
