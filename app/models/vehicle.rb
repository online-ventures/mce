class Vehicle < ApplicationRecord
  DAYS_TO_REMAIN_NEW = 30.freeze

  include Destroyable

  scope :recent, -> do
    where('created_at > ?', DAYS_TO_REMAIN_NEW.days.ago)
      .order(created_at: :desc)
      .limit(5)
  end
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where('deleted_at IS NOT NULL') }
  scope :random_featured, -> do
    alive
      .where(sold: false, featured: true)
      .order('RANDOM()')
      .limit(1)
  end

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
  has_many :photos, -> { order(featured: :desc, name: :asc) }
  has_one :purchase
  has_one :subscriber, through: :purchase
  has_many :inquiries
  accepts_nested_attributes_for :photos
  has_and_belongs_to_many :features, join_table: 'vehicles_features', touch: true
  has_and_belongs_to_many :disclosures, join_table: 'vehicles_disclosures', before_add: :validates_unique_disclosure

  after_create :ensure_it_has_the_intro_disclosure

  def to_s(join=' ')
    "#{year} #{make.name} #{model.name}".gsub(' ', join)
  end

  def type
    body_type&.vehicle_type
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
    self.featured_id = photo.id
    photos.where(featured: true).update_all featured: false
    photo.update featured: true
    save
  end

  def featured_photo
    photos.featured.first
  end

  def edit_purchase_path
    routes = Rails.application.routes.url_helpers
    return routes.edit_vehicle_purchase_path(self, purchase) if purchase
    routes.new_vehicle_purchase_path(self)
  end

  def status_text
    sold ? 'Sold' : status.name.titleize
  end

  def self.delete_old_photos
    where('created_at < ?', 6.months.ago)
  end

  private

  def ensure_it_has_the_intro_disclosure
    the_intro_disclosure = Disclosure.find(1)

    # Ensure it has the intro disclosure
    self.disclosures << the_intro_disclosure unless self.disclosures.include? the_intro_disclosure
  end

  # http://stackoverflow.com/questions/4988630/habtm-uniqueness-constraint
  def validates_unique_disclosure(disclosure)
    raise ActiveRecord::Rollback if self.disclosures.include? disclosure
  end
end
