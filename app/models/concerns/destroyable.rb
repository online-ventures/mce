#
# Activeable
#
# Allow a model to be marked active or inactive
#
module Destroyable
  extend ActiveSupport::Concern

  included do
    scope :deleted,   -> { where.not(deleted_at: nil) }
    scope :alive,     -> { where(deleted_at: nil) }

    # Store a list of callbacks to be run when a model is destroyed.
    cattr_accessor :destroyed_callbacks
    self.destroyed_callbacks = []

    def self.after_destroyed(&block)
      destroyed_callbacks.push(block)
    end

    def deleted?
      deleted_at.present?
    end

    def destroy
      self.deleted_at = DateTime.now
      save unless new_record?
      self.class.destroyed_callbacks.each do |proc|
        proc.call(self)
      end
    end

    def restore
      self.deleted_at = nil
      save(validate: false)
    end
  end
end
