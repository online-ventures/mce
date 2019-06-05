class Drivable < ApplicationRecord
  include Destroyable

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end
end
