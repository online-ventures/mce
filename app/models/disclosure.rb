class Disclosure < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :body, :deleted_at, :name

  def restore
    self.deleted_at = nil
    save!
  end
end
