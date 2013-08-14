class Disclosure < ActiveRecord::Base
  attr_accessible :body, :deleted_at, :name

  def restore
    self.deleted_at = nil
    save!
  end
end
