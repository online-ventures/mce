class PhotosController < ApplicationController
  before_action :require_user
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
      if save_photos
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

  private

  def save_photos
    if params[:photo][:zip]
      process_zipped_file
    else
      create_single_photo
    end
  end

  def create_single_photo
    @photo = @vehicle.photos.new(photo_params)
    @photo.save
  end

  def process_zipped_file
    file = params[:photo][:zip]
    Zip::File.open(file.to_io).each do |entry|
      next unless entry.name.match? /\.(png|gif|jpe?g)$/i
      name = File.basename(entry.name, '.*')
      photo = @vehicle.photos.new(name: name)
      type = 'image/jpg' # TODO: properly extract the type from name
      tempfile = create_temp_file(entry, name)
      io = tempfile.open
      photo.file.attach(io: io, filename: entry.name, content_type: type)
      photo.save
    end
  end

  def create_temp_file(zip_entry, name)
    tempfile = Tempfile.new(name, '/tmp')
    tempfile.binmode
    tempfile.write zip_entry.get_input_stream.read
    tempfile
  end

  def photo_params
    params.require(:photo).permit(:file, :vehicle_id, :vehicles_photo_id, :deleted_at, :featured)
  end
end
