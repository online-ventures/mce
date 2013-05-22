class Vehicle < ActiveRecord::Base
  attr_accessible :burns, :description, :ebay, :engine_type, :miles, :price, :photos, :stains, :stock_number, :subtitle, :tears, :vin, :year,
                  :make_id, :make, :model, :model_id, :warranty_id, :title_id, :engine_id, :transmission_id, :ext_color_id, :int_color_id, :status_id,
                  :damage_id, :paint_id, :interior_id, :drivable_id, :suspension_id

  belongs_to :make, :autosave => true
  belongs_to :model, :autosave => true
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
  validates :make_id, :presence => true
  validates :model_id, :presence => true
  validates :stock_number, :presence => true, :length => {:minimum => 2, :maximum => 10}
  validates :status_id, :presence => true

end
