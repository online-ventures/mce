class Make < ApplicationRecord
  has_many :models

  def to_s
    name
  end
end
