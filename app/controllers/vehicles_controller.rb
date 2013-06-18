class VehiclesController < ApplicationController
  before_filter :require_user, except: [:show, :inventory]
  caches_page :inventory, layout: false


  # GET /vehicles
  # GET /vehicles.json
  def index
    if params[:deleted] and params[:deleted] == 'true'
      @vehicles = Vehicle.unscoped.inactive.order('updated_at desc').all
    else
      @vehicles = Vehicle.unscoped.active.order('updated_at desc').all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vehicles }
    end
  end

  def inventory
    @vehicles = Vehicle.order("featured DESC, ebay DESC, id DESC").all
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @vehicle = Vehicle.unscoped.find(params[:id])
    if @vehicle.deleted_at and !current_user
      redirect_to '/vehicles/inventory', notice: 'That vehicle cannot be found' and return
    end
    unless params[:name]
      redirect_to seo_vehicle_path(id: @vehicle.id, name: @vehicle.to_s('-')), status: 301 and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vehicle }
      format.ebay # show.ebay.erb
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
    @vehicle = Vehicle.unscoped.find(params[:id])
    @makes = Make.all
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new params[:vehicle]
    @vehicle.make = Make.find_or_initialize_by_name params[:make][:name]
    @vehicle.model = Model.find_or_initialize_by_name params[:model][:name]
    respond_to do |format|
      if @vehicle.valid? && @vehicle.make.valid? && @vehicle.model.valid?
        @vehicle.save
        @vehicle.model.update_attributes({make_id: @vehicle.make_id })
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
        format.json { render json: @vehicle, status: :created, location: @vehicle }
      else
        format.html { render action: "new" }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vehicles/1
  # PUT /vehicles/1.json
  def update
    @vehicle = Vehicle.unscoped.find(params[:id])
    @vehicle.make = Make.find_or_initialize_by_name params[:make][:name] if params[:make]
    @vehicle.model = Model.find_or_initialize_by_name params[:model][:name] if params[:make]
    Rails.cache.delete(@vehicle)

    params[:vehicle].each do |k,v|
      params[:vehicle][k] = true if v == 'true'
      params[:vehicle][k] = false if v == 'false'
    end
    respond_to do |format|
      if @vehicle.valid? && @vehicle.make.valid? && @vehicle.model.valid?
        @vehicle.update_attributes(params[:vehicle])
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        format.json { head :no_content }
        format.js   {  }
      else
        format.html { render action: "edit" }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
        format.js   { render json: @vehicle.errors }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle = Vehicle.unscoped.find(params[:id])
    Rails.cache.delete(@vehicle)
    if @vehicle.deleted_at
      @vehicle.deleted_at = nil
      @vehicle.photos.update_all(deleted_at: nil)
      @vehicle.save
    else
      @vehicle.destroy
    end

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
      format.js   { }
    end
  end
end
