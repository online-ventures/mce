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

    # Store a list of callbacks to be run when a model is destroyed/restored
    cattr_accessor :destroyed_callbacks
    cattr_accessor :restored_callbacks
    self.destroyed_callbacks = []
    self.restored_callbacks = []

    def self.after_destroy(&block)
      destroyed_callbacks.push(block)
    end

    def self.after_restore(&block)
      restored_callbacks.push(block)
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
      self.class.restored_callbacks.each do |proc|
        proc.call(self)
      end
    end
  end
end
