class Vehicle < ActiveRecord::Base
  # populates deleted_at, and prevents deletion
  acts_as_paranoid
  scope :active, where(deleted_at: nil)
  scope :inactive, where('deleted_at IS NOT NULL')
  scope :random_featured, where(featured: true).order('RANDOM()').limit(1)

  attr_accessible :burns, :description, :ebay, :engine_type, :miles, :price, :photos, :stains, :stock_number, :subtitle, :tears, :vin, :year,
                  :make_id, :make, :model, :model_id, :warranty_id, :title_id, :engine_id, :transmission_id, :ext_color_id, :int_color_id, :status_id,
                  :damage_id, :paint_id, :interior_id, :drivable_id, :suspension_id, :featured_id, :featured, :sold

  belongs_to :make
  belongs_to :model
  belongs_to :damage
  belongs_to :drivable
  belongs_to :engine
  belongs_to :paint, :class_name => 'Condition'
  belongs_to :interior, :class_name => 'Condition'
  belongs_to :ext_color, :class_name => 'Color'
  belongs_to :int_color, :class_name => 'Color'
  belongs_to :status
  belongs_to :suspension
  belongs_to :title
  belongs_to :transmission
  belongs_to :warranty
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
  has_and_belongs_to_many :features, join_table: 'vehicles_features'

  validates :year, :presence => true, :numericality => true
  #validates :make_id, :presence => true
  #validates :model_id, :presence => true
  validates :stock_number, :presence => true, :length => {:minimum => 2, :maximum => 10}
  validates :status_id, :presence => true

	def to_s(join=' ')
    bits = [year.to_s, make.name, model.name]
		bits.join(join)
  end

  def new
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
      if photo
        photo.image
      else
        false
      end
    else
      false
    end
  end

  def featured_url(size = :original)
    if photos.any?
      featured_photo ? featured_photo.url(size) : photos.first.image.url(size)
    else
      false
    end
  end

  def word_price
    if sold?
      'Sold'
    elsif !ebay.blank?
      "<a href=\"#{ebay}\">Bid On Ebay</a>".html_safe
    else
      ActionController::Base.helpers.number_to_currency(price, precision: 0)
    end
  end

  def word_miles
    if miles
      ActionController::Base.helpers.number_to_human(miles, units: {unit: 'mi', thousand: 'k'}, precision: 0).delete ' '
    end
  end

  def word_status
    if new
      'new'
    else
      status.to_s
    end
  end
end
