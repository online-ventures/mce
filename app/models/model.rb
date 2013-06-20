class Model < ActiveRecord::Base
  attr_accessible :make_id, :name
  belongs_to :make
end
