class Model < ActiveRecord::Base
  attr_accessible :make_id, :name
  belongs_to :make


  def self.create_from_params(params)
    if params[:model][:name] and params[:vehicle][:model_id].empty?
      @vehicle.model = Model.find_or_create_by_name params[:model][:name]
      @vehicle.model.make_id ||= @vehicle.make_id
      @vehicle.model.id
    end
  end
end
