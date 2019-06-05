class DrivablesController < ApplicationController
  # GET /drivables
  # GET /drivables.json
  def index
    if params[:deleted] and params[:deleted] == 'true'
      @drivables = Drivable.order(:id).where('deleted_at IS NOT NULL')
    else
      @drivables = Drivable.order(:id).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drivables }
    end
  end

  # GET /drivables/1
  # GET /drivables/1.json
  def show
    respond_to do |format|
      format.html { redirect_to drivables_path }
      format.json { render json: Drivable.find(params[:id]) }
    end
  end

  # GET /drivables/new
  # GET /drivables/new.json
  def new
    @drivable = Drivable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @drivable }
    end
  end

  # GET /drivables/1/edit
  def edit
    @drivable = Drivable.find(params[:id])
  end

  # POST /drivables
  # POST /drivables.json
  def create
    @drivable = Drivable.new(drivable_params)

    respond_to do |format|
      if @drivable.save
        format.html { redirect_to drivables_path, notice: 'Drivable was successfully created.' }
        format.json { render json: @drivable, status: :created, location: @drivable }
      else
        format.html { render action: "new" }
        format.json { render json: @drivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drivables/1
  # PUT /drivables/1.json
  def update
    @drivable = Drivable.find(params[:id])

    respond_to do |format|
      if @drivable.update_attributes(drivable_params)
        format.html { redirect_to drivables_path, notice: 'Drivable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drivable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivables/1
  # DELETE /drivables/1.json
  def destroy
    @drivable = Drivable.find(params[:id])
    @drivable.destroy

    respond_to do |format|
      format.html { redirect_to drivables_url }
      format.json { head :no_content }
    end
  end

  def restore
    @drivable = Drivable.find(params[:id])
    @drivable.restore

    respond_to do |format|
      format.html { redirect_to drivables_url }
      format.json { head :no_content }
    end
  end

  private

  def drivable_params
    params.require(:drivable).permit(:name, :body)
  end
end
