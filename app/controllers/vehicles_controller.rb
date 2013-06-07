class VehiclesController < ApplicationController
  before_filter :require_user, except: [:show, :inventory]

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.order('updated_at desc').all

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
    @vehicle = Vehicle.find(params[:id])
    unless params[:name]
      redirect_to seo_vehicle_path(id: @vehicle.id, name: @vehicle.to_s('-')), status: 301 and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vehicle }
      format.ebay { render 'vehicles/ebay.html.erb' }
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
    @vehicle.build_make
    @vehicle.build_model
    @makes = Make.all
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new params[:vehicle]
    @vehicle.build_make
    @vehicle.build_model
    abort @vehicle.to_yaml

    respond_to do |format|
      if @vehicle.save
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
    @vehicle = Vehicle.find(params[:id])

    params[:vehicle].each do |k,v|
      params[:vehicle][k] = true if v == 'true'
      params[:vehicle][k] = false if v == 'false'
    end

    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
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
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end
end
