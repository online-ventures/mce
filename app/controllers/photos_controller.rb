class PhotosController < ApplicationController

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @photo = Photo.new
  end

  def create
    @start = Time.now
    @vehicle = Vehicle.find(params[:id])
		@photo = @vehicle.photos.new(params[:photo])
		if @photo.valid?
			@photo.save
      puts "\n\nTime Elapsed: #{(Time.now - @start)} seconds\n\n\n"
			redirect_to :show, notice: 'Successfully uploaded'
		else
			render action: :index
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    if @photo.active
      # Error
    end
    respond_to do |format|
      format.js { }
    end
  end
end