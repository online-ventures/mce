class Model < ActiveRecord::Base
  attr_accessible :make_id, :name
  belongs_to :make

  def to_s
    name
  end
end
