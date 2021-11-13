class PhotosController < ApplicationController
  before_action :require_user
  respond_to :js, only: %i[destroy destroy_all]

  def index
    @vehicle = Vehicle.find(params[:vehicle_id])
    @photo = Photo.new
    @photos = @vehicle.photos
  end

  def update
    @photo = Photo.find(params[:id])
    Vehicle.find(params[:vehicle_id]).feature @photo if params[:featured] == 'true'
    @photo.activate if params[:activate] == 'true'
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
      if save_photos
        redirect_to vehicle_photos_path(@vehicle), notice: 'Successfully uploaded'
      else
        render action: :index
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.vehicle.update(:featured_id, nil) if @photo.featured?
    @photo.destroy
  end

  def destroy_all
    @vehicle = Vehicle.find(params[:vehicle_id])
    @vehicle.photos.destroy_all
  end

  private

  def save_photos
    if params[:photo][:zip]
      process_zipped_file
    else
      create_single_photo
    end
  end

  def create_single_photo
    @photo = @vehicle.photos.create
    file = params[:photo][:file]
    @photo.attach_file(file.path, name: file.original_filename)
  end

  def process_zipped_file
    file = params[:photo][:zip]
    Zip::File.open(file.to_io).each do |entry|
      next unless entry.name.match?(/\.(png|gif|jpe?g)$/i)

      photo = @vehicle.photos.create
      filename = File.basename(entry.name)
      tempfile = create_temp_file(entry, filename).open
      photo.attach_file(tempfile.path, name: filename)
    end
  end

  def create_temp_file(zip_entry, name)
    tempfile = Tempfile.new(name, '/tmp')
    tempfile.binmode
    tempfile.write zip_entry.get_input_stream.read
    tempfile.rewind
    tempfile
  end

  def photo_params
    params.require(:photo).permit(:file, :vehicle_id, :vehicles_photo_id, :deleted_at, :featured)
  end
end
