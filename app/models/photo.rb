class Photo < ActiveRecord::Base
  attr_accessible :image, :vehicle_id, :vehicles_photo_id
  belongs_to :vehicle
  has_attached_file :image, styles: {
      thumb: '150x150#',
      normal: '640x480#'
  }

  before_create :set_vehicles_photo_id

  def set_vehicles_photo_id
    self.vehicles_photo_id = self.vehicle.photos.count + 1
  end
end