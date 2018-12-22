class Model < ApplicationRecord
  belongs_to :make

  def to_s
    name
  end
end
