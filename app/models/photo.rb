class Photo < ActiveRecord::Base
  attr_accessible :image, :vehicle_id

  has_attached_file :image, styles: {
      thumb: '150x150#',
      normal: '640x480#'
  }

  belongs_to :vehicle
end