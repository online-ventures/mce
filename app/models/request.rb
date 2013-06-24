class Request < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :body_type_id, :subscriber_id, :vehicle_id, :subscriber

  belongs_to :body_type
  belongs_to :subscriber
  belongs_to :vehicle
  accepts_nested_attributes_for :subscriber

  #validates :body_type_id, presence: true, if: 'vehicle_id.blank?'

  before_create :extract_body_type

  def initialize(request=nil)
    # properly assign subscriber
    if request
      request[:subscriber] = Subscriber.find_or_create_by_email(request[:subscriber][:email]) || nil
      abort request.to_yaml
    end
    super(request)
  end

  def extract_body_type
    abort 'doop'
    self.body_type_id = vehicle.body_type_id if vehicle
  end
end
