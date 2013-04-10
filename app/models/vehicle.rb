class Vehicle < ActiveRecord::Base
  attr_accessible :burns, :description, :ebay, :engine_type, :miles, :price, :stains, :stock_number, :subtitle, :tears, :vin, :year, :active
  attr_readonly :deleted_at
  has_one :make
  has_one :model
  has_one :damage
  has_one :drivable
  has_one :engine
  has_one :paint, class_name: 'condition'
  has_one :interior, class_name: 'condition'
  has_one :ext_color, class_name: 'color'
  has_one :int_color, class_name: 'color'
  has_one :interior_condition
  has_one :status
  has_one :suspension
  has_one :title
  has_one :trans
  has_one :warranty

  has_and_belongs_to_many :features

  scope :active, where(active: true)
  scope :by_stock, order('stock_number asc')

  before_destroy :set_inactive

  def set_inactive
    self.active = false
    self.deleted_at = Time.now
    false
  end

  validates :year, presence: true, numericality: true
  validates :make_id, presence: true
  validates :model_id, presence: true
  validates :stock_number, presence: true, length: {minimum: 2, maximum: 10}
  validates :status_id, presence: true
end
