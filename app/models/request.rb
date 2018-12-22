class Request < ApplicationRecord
  acts_as_paranoid

  belongs_to :body_type
  belongs_to :subscriber, touch: true
  belongs_to :vehicle
  accepts_nested_attributes_for :subscriber

  #validates :body_type_id, presence: true, if: 'vehicle_id.blank?'

  def initialize(request=nil)
    # properly assign subscriber
    if request && request[:subscriber] && request[:subscriber][:email]
      request[:subscriber] = Subscriber.find_or_initialize_by email: request[:subscriber][:email]
    end
    super(request)
  end

  def vehicle
    Vehicle.unscoped.find(vehicle_id)
  end

  def is_duplicate?
    params = {}
    params[:subscriber_id] = subscriber_id if subscriber_id
    params[:vehicle_id] = vehicle_id if vehicle_id
    params[:body_type_id] = body_type_id if body_type_id
    Request.unscoped.where(params).any?
  end
end
