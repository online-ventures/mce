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
    @features = Feature.alive
    @all_features = Feature.alive

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end

  # POST /features
  # POST /features.json
  def create
    # Prefer a live feature with this name; otherwise revive a deleted one (or start a new one).
    name = params[:feature][:name]
    @feature = Feature.alive.find_by(name: name) || Feature.find_or_initialize_by(name: name)
    @feature.deleted_at = nil

    if @feature.save
      if params[:vehicle_id]
        @vehicle = Vehicle.find(params[:vehicle_id])
        @vehicle.features << @feature unless @feature.in? @vehicle.features
      end

      respond_to do |format|
        format.html { redirect_to features_path, notice: "\"#{@feature.name}\" was added." }
        format.json { render json: @feature, status: :created, location: @feature }
        format.js   { render 'features/create' }
      end
    else
      respond_to do |format|
        format.html do
          @features = Feature.alive.order(:order).all
          render action: 'manage'
        end
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
      respond_to do |format|
        format.json { head :no_content }
        format.js
      end
    elsif @feature.update(feature_params)
      respond_to do |format|
        format.html { redirect_to features_path, notice: "\"#{@feature.name}\" was updated." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
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
      format.html { redirect_to features_url, notice: "\"#{@feature.name}\" was deleted." }
      format.json { head :no_content }
      format.js
    end
  end

  def manage
    @feature = Feature.new
    @features = Feature.alive.order(:order).all
  end

  # PATCH /features/1/move?direction=up|down
  def move
    @feature = Feature.find(params[:id])
    direction = params[:direction].to_s

    if %w[up down].include?(direction)
      @feature.move(direction)
      redirect_to features_path
    else
      redirect_to features_path, alert: 'Invalid direction.'
    end
  end

  def new
    @feature = Feature.new
  end

  def edit
    @feature = Feature.find(params[:id])
  end

  def show
    @feature = Feature.find(params[:id])
  end

  private

  def feature_params
    params.require(:feature).permit(:name, :order, :deleted_at)
  end
end
