class VehiclesController < ApplicationController
  require 'rdiscount'
  before_action :require_user, except: %i[show inventory index]

  # GET /vehicles
  # GET /vehicles.json
  def index
    redirect_to inventory_vehicles_path and return unless current_user

    @vehicles = if params[:deleted] && (params[:deleted] == 'true')
                  Vehicle.inactive.order(:stock_number).all
                else
                  Vehicle.active.order(:stock_number).all
                end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vehicles }
    end
  end

  def inventory
    @vehicles = Vehicle.alive.order('featured DESC, ebay DESC, id DESC').all
    @recent = Vehicle.recent.pluck(:id)
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @vehicle = Vehicle.find(params[:id])
    @subscriber = Subscriber.new
    @inquiry = @subscriber.inquiries.build vehicle_id: @vehicle.id

    if @vehicle.deleted_at && !current_user
      redirect_to '/vehicles/inventory', notice: 'That vehicle cannot be found'
      return
    end

    unless params[:name]
      redirect_to seo_vehicle_path(id: @vehicle.id, name: @vehicle.to_s('-')), status: 301
      nil
    end

    respond_to do |format|
      format.html
      format.json { render json: @vehicle }
    end
  end

  # GET /vehicles/1/ebay
  def ebay
    @vehicle = Vehicle.find(params[:id] || params[:vehicle_id])
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  # GET /vehicles/new
  # GET /vehicles/new.json
  def new
    @vehicle = Vehicle.new
    @vehicle.build_model
    @vehicle.build_make
    @makes = Make.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vehicle }
    end
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle = Vehicle.find(params[:id])
    @makes = Make.all
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new vehicle_params
    @vehicle.make = Make.find_or_initialize_by name: params[:make][:name]
    @vehicle.model = Model.find_or_initialize_by name: params[:model][:name]
    respond_to do |format|
      if @vehicle.valid? && @vehicle.make.valid? && @vehicle.model.valid?
        @vehicle.save
        @vehicle.model.update(:make_id, @vehicle.make_id)
        format.html { redirect_to vehicle_features_path(@vehicle), notice: 'Vehicle was successfully created.' }
        format.json { render json: @vehicle, status: :created, location: @vehicle }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vehicles/1
  # PUT /vehicles/1.json
  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.make = Make.find_or_initialize_by name: params[:make][:name] if params[:make]
    @vehicle.model = Model.find_or_initialize_by name: params[:model][:name] if params[:make]
    @vehicle.model.make = @vehicle.make unless @vehicle.model.make

    params[:vehicle].each do |k, v|
      params[:vehicle][k] = true if v == 'true'
      params[:vehicle][k] = false if v == 'false'
    end
    respond_to do |format|
      if @vehicle.valid? && @vehicle.make.valid? && @vehicle.model.valid?
        @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        format.json { head :no_content }
        format.js   {}
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
        format.js   { render json: @vehicle.errors }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
      format.js   {}
    end
  end

  def restore
    @vehicle = Vehicle.find(params[:id])
    @vehicle.restore

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(
      :burns,
      :body_type,
      :description,
      :ebay,
      :engine_type,
      :miles,
      :price,
      :photos,
      :stains,
      :stock_number,
      :subtitle,
      :tears,
      :vin,
      :year,
      :make_id,
      :make,
      :model,
      :model_id,
      :warranty_id,
      :title_id,
      :engine_id,
      :transmission_id,
      :ext_color_id,
      :int_color_id,
      :status_id,
      :deleted_at,
      :damage_id,
      :exterior_id,
      :interior_id,
      :drivable_id,
      :suspension_id,
      :featured_id,
      :featured,
      :sold,
      :body_type_id,
      :disclosures,
      disclosure_ids: []
    )
  end
end
