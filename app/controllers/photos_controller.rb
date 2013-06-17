class PhotosController < ApplicationController

  def index
    @vehicle = Vehicle.unscoped.find(params[:vehicle_id])
    @photo = Photo.new
    if params[:deleted] == 'true'
      @photos = @vehicle.photos.unscoped.inactive
    else
      @photos = @vehicle.photos
    end
  end

  def update
    @photo = Photo.unscoped.find(params[:id])
    if params[:featured] == 'true'
      Vehicle.find(params[:vehicle_id]).feature @photo
    end
    if params[:activate] == 'true'
      @photo.activate
    end
    if @photo.save
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    @vehicle = Vehicle.find(params[:vehicle_id])
		@photo = @vehicle.photos.new(params[:photo])
		if @photo.valid?
			@photo.save
			redirect_to vehicle_photos_path(@vehicle), notice: 'Successfully uploaded'
		else
			render action: :index
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.featured?
      @photo.vehicle.update_attribute(:featured_id, nil)
    end
    @photo.destroy
    respond_to do |format|
      format.js
    end
  end
end