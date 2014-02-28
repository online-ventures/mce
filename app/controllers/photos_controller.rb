class PhotosController < ApplicationController
  before_filter :require_user
  respond_to :js, only: [:destroy, :destroy_all]

  def index
    @vehicle = Vehicle.unscoped.find(params[:vehicle_id])
    @photo = Photo.new
    @photos = @vehicle.photos
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
    @start_time = Time.now
    @vehicle = Vehicle.find(params[:vehicle_id])
    unless @vehicle.nil?
      @photo = @vehicle.photos.new(params[:photo])
      if @photo.valid?
        @photo.save
        redirect_to vehicle_photos_path(@vehicle), notice: 'Successfully uploaded'
      else
        render action: :index
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.featured?
      @photo.vehicle.update_attribute(:featured_id, nil)
    end
    @photo.destroy
  end

  def destroy_all
    @vehicle = Vehicle.find(params[:vehicle_id])
    @vehicle.photos.destroy_all
  end
end
