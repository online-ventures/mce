class Drivable < ApplicationRecord
  acts_as_paranoid

  def to_s(join=' ')
    name.downcase.split(' ').join(join)
  end

  def restore
    self.deleted_at = nil
    save!
  end
end
