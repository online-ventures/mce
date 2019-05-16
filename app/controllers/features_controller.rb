class FeaturesController < ApplicationController
  before_action :require_user
  # GET /features
  # GET /features.json
  def index
    if params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      @vehicle_features = @vehicle.features
    end
    @feature = Feature.new
    @features = Feature.all
    @all_features = Feature.unscoped.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.find_or_create_by(name: params[:feature][:name])
    @feature.update(deleted_at: nil)
    if params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      @vehicle.features << @feature unless @feature.in? @vehicle.features
    end
    respond_to do |format|
      if @feature.save
        format.html
        format.json { render json: @feature, status: :created, location: @feature }
        format.js   { render 'features/create' }
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.json
  def update
    @feature = Feature.find(params[:id])
    if params[:vehicle_id]
      @method = Vehicle.find(params[:vehicle_id]).toggle_feature(@feature)
    end

    respond_to do |format|
      if @feature.update_attributes(feature_params)
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to features_url }
      format.json { head :no_content }
      format.js
    end
  end

  def manage
    @feature = Feature.new
    @features = Feature.all
  end

  def move
    @feature = Feature.find(params[:id])
    @success = @feature.move_to_order(params[:to])
    respond_to do |format|
      format.json
    end
  end

  private

  def feature_params
    params.require(:feature).permit(:name, :order, :deleted_at)
  end
end
