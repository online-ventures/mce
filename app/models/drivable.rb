class Drivable < ActiveRecord::Base
  attr_accessible :name

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end
end
