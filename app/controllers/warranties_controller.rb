class WarrantiesController < ApplicationController
  before_filter :require_user

  # GET /warranties
  # GET /warranties.json
  def index
    if params[:deleted]
      @warranties = Warranty.unscoped.where('deleted_at IS NOT NULL')
    else
      @warranties = Warranty.order(:id).all
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @warranties }
    end
  end

  # GET /warranties/1
  # GET /warranties/1.json
  def show
    respond_to do |format|
      format.html { redirect_to :index }
      format.json { render json: Warranty.find(params[:id]) }
    end
  end

  # GET /warranties/new
  # GET /warranties/new.json
  def new
    @warranty = Warranty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @warranty }
    end
  end

  # GET /warranties/1/edit
  def edit
    @warranty = Warranty.find(params[:id])
  end

  # POST /warranties
  # POST /warranties.json
  def create
    @warranty = Warranty.new(params[:warranty])

    respond_to do |format|
      if @warranty.save
        format.html { redirect_to warranties_path, notice: 'Warranty was successfully created.' }
        format.json { render json: @warranty, status: :created, location: @warranty }
      else
        format.html { render action: "new" }
        format.json { render json: @warranty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /warranties/1
  # PUT /warranties/1.json
  def update
    @warranty = Warranty.find(params[:id])

    respond_to do |format|
      if @warranty.update_attributes(params[:warranty])
        format.html { redirect_to warranties_path, notice: 'Warranty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @warranty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warranties/1
  # DELETE /warranties/1.json
  def destroy
    @warranty = Warranty.unscoped.find(params[:id])
    @warranty.destroy

    respond_to do |format|
      format.html { redirect_to warranties_url }
      format.json { head :no_content }
    end
  end

  def restore
    @warranty = Warranty.unscoped.find(params[:id])
    @warranty.restore

    respond_to do |format|
      format.html { redirect_to warranties_url }
      format.json { head :no_content }
    end
  end
end