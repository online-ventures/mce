class Vehicle < ActiveRecord::Base
  # populates deleted_at, and prevents deletion
  acts_as_paranoid
  scope :active, where(deleted_at: nil)
  scope :inactive, where('deleted_at IS NOT NULL')
  scope :random_featured, order('featured DESC').order('RANDOM()').limit(1)

  attr_accessible :burns, :body_type, :description, :ebay, :engine_type, :miles, :price, :photos, :stains, :stock_number, :subtitle, :tears, :vin, :year,
                  :make_id, :make, :model, :model_id, :warranty_id, :title_id, :engine_id, :transmission_id, :ext_color_id, :int_color_id, :status_id,
                  :damage_id, :exterior_id, :interior_id, :drivable_id, :suspension_id, :featured_id, :featured, :sold, :body_type_id

  belongs_to :make
  belongs_to :model
  belongs_to :body_type
  belongs_to :damage
  belongs_to :drivable
  belongs_to :engine
  belongs_to :exterior, :class_name => 'Condition'
  belongs_to :interior, :class_name => 'Condition'
  belongs_to :ext_color, :class_name => 'Color'
  belongs_to :int_color, :class_name => 'Color'
  belongs_to :status
  belongs_to :suspension
  belongs_to :title
  belongs_to :transmission
  belongs_to :warranty
  has_many :photos
  has_many :requests
  accepts_nested_attributes_for :photos
  has_and_belongs_to_many :features, join_table: 'vehicles_features'

  validates :year, presence: true, :numericality => true
  #validates :make_id, presence: true
  #validates :model_id, presence: true
  validates :stock_number, presence: true, length: { in: 2..10 }
  validates :status_id, presence: true
  #validates :vin, length: { is: 17 }, format: /[^ioq]{17}/ # https://en.wikipedia.org/wiki/Vehicle_Identification_Number

  after_save :update_associated_photos

	def to_s(join=' ')
    "#{year} #{make.name} #{model.name}".gsub(' ', join)
  end

  def is_new?
    created_at > 5.days.ago
  end

  def toggle_feature(feature)
    if feature.in? features
      features.delete(feature)
      save
      :removed
    else
      features << feature
      save
      :added
    end
  end

  def feature(photo)
    if photo.is_a? Integer
      self.featured_id = photo
    elsif photo.is_a? Photo
      self.featured_id = photo.id
    end
    save
  end

  def featured_photo
    if featured_id
      photo = Photo.find(featured_id)
      photo ? photo.image : false
    end
  end

  def featured_url(size = :original)
    #                                           to_a orders by id DESC
    featured_photo ? featured_photo.url(size) : photos.to_a.last.image.url(size) if photos.any?
  end

  def restore
    self.deleted_at = nil
    self.photos.update_all(deleted_at: nil)
    save!
  end

  def update_associated_photos
    # Rename all the photos so they translate to the new pathname
    # http://stackoverflow.com/questions/2708115/paperclip-renaming-files-after-theyre-saved
    #
    unless model_id_was.nil? || make_id_was.nil?
      if self.year_changed? || self.model_id_changed? || self.make_id_changed?
        old_name = "#{id}/#{year_was}_#{Make.find(make_id_was).name}_#{Model.find(model_id_was).name}"
        bucket = AWS::S3::Bucket.new ENV['S3_BUCKET_NAME']
        photos.each do |photo|
          photo.rename_files(old_name)
        end
        bucket.acl = :public_read
      end
    end
  end
end
