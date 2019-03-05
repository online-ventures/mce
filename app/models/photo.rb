require 'zip'
class Photo < ApplicationRecord
  # populates deleted_at, and prevents deletion
  belongs_to :vehicle, touch: true

  # Active storage
  has_one_attached :file

  # Validation
  validates :file, presence: {message: 'must be chosen before saving'}

  # Callbacks
  before_create :set_vehicles_photo_id
  before_destroy :delete_file

  # scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where('deleted_at IS NOT NULL') }
  # smart sort, putting featured first:

  def vehicle
    Vehicle.unscoped{ super }
  end

  def featured?
    featured
  end

  def self.purge_old_photos
    unscoped
      .joins(:vehicle)
      .where('"vehicles".deleted_at < ?', 6.months.ago)
      .each { |photo| photo.destroy }
  end

  private

  def set_vehicles_photo_id
    self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
  end

  def delete_file
    file.purge
  end
end
