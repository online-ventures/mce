class Vehicle < ActiveRecord::Base
	# populates deleted_at, and prevents deletion
	acts_as_paranoid
	scope :active, where(deleted_at: nil)
	scope :inactive, where('deleted_at IS NOT NULL')
	scope :random_featured, where(sold: false).order('featured DESC').order('RANDOM()').limit(1)

	attr_accessible :burns, :body_type, :description, :ebay, :engine_type, :miles, :price, :photos, :stains, :stock_number, :subtitle, :tears, :vin, :year,
					:make_id, :make, :model, :model_id, :warranty_id, :title_id, :engine_id, :transmission_id, :ext_color_id, :int_color_id, :status_id, :deleted_at,
					:damage_id, :exterior_id, :interior_id, :drivable_id, :suspension_id, :featured_id, :featured, :sold, :body_type_id, :disclosures, :disclosure_ids

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
	has_and_belongs_to_many :features, join_table: 'vehicles_features', after_add: :touch
	has_and_belongs_to_many :disclosures, join_table: 'vehicles_disclosures', before_add: :validates_unique_disclosure

	after_create :ensure_it_has_the_intro_disclosure

	def to_s(join=' ')
		"#{year} #{make.name} #{model.name}".gsub(' ', join)
	end

	def is_new?
		created_at > 5.days.ago
	end

	def photos
		super.prioritize_id featured_id
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
		photos.limit(1).first
	end

	def featured_url(size = :original)
		featured_photo.present? ? featured_photo.image.url(size) : false
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

  def touch(object)
    update_attributes(updated_at: Time.now)
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
