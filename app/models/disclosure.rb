class Disclosure < ApplicationRecord
  acts_as_paranoid

  def restore
    self.deleted_at = nil
    save!
  end
end
