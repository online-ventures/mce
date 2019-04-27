require 'zip'
class Photo < ApplicationRecord
  # populates deleted_at, and prevents deletion
  belongs_to :vehicle, touch: true

  # Callbacks
  before_create :set_vehicles_photo_id
  before_destroy :delete_file

  scope :featured, -> { where(featured: true) }

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

  def file_path
    "vehicles/#{vehicle_id}/photos/#{id}"
  end

  def attach_file(file, name: '')
    self.name = name || File.basename(file.path)
    self.uploaded = AmazonService.upload_photo(self, file)
    save
  end

  private

  def set_vehicles_photo_id
    self.vehicles_photo_id = (vehicle.photos.maximum(:vehicles_photo_id)|| 0) + 1
  end

  def delete_file
    AmazonService.delete_photo self
  end
end
