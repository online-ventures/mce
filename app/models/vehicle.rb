class Vehicle < ApplicationRecord
  # populates deleted_at, and prevents deletion
  acts_as_paranoid
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where('deleted_at IS NOT NULL') }
  scope :random_featured, -> { where(sold: false).order('featured DESC').order('RANDOM()').limit(1) }

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
    self.featured_id = photo.id
    photos.where(featured: true).update_all featured: false
    photo.update featured: true
    save
  end

  def featured_photo
    photos.featured.first
  end

  def destroy
    self.updated_at = Time.now
    save!
    super
  end

  def restore
    self.deleted_at = nil
    self.photos.update_all(deleted_at: nil)
    save!
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
