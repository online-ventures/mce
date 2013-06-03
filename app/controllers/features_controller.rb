class FeaturesController < ApplicationController
  # GET /features
  # GET /features.json
  def index
    @feature = Feature.new
    if params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      @vehicle_features = @vehicle.features
    end
    @features = Feature.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.find_or_create_by_name(params[:feature][:name])
    if params[:vehicle_id]
      @vehicle = Vehicle.find(params[:vehicle_id])
      @vehicle.features << @feature unless @feature.in? @vehicle.features
    end
    respond_to do |format|
      if @feature.save
        format.json { render json: @feature, status: :created, location: @feature }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
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
      if @feature.update_attributes(params[:feature])
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
    end
  end

  def manage
    @features = Feature.all
  end

  def move
    @feature = Feature.find(params[:id])
    @success = @feature.move_to_order(params[:to])
    respond_to do |format|
      format.json
    end
  end
end