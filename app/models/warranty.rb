class Warranty < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :name, :body

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end

  def restore
    self.deleted_at = nil
    save!
  end
end
