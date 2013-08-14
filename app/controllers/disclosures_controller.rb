class DisclosuresController < ApplicationController
  before_filter :require_user
  # GET /disclosures
  # GET /disclosures.json
  def index
    @disclosures = Disclosure.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @disclosures }
    end
  end

  # GET /disclosures/1
  # GET /disclosures/1.json
  def show
    respond_to do |format|
      format.html { redirect_to :index}
      format.json { render json: Disclosure.find(params[:id]) }
    end
  end

  # GET /disclosures/new
  # GET /disclosures/new.json
  def new
    @disclosure = Disclosure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @disclosure }
    end
  end

  # GET /disclosures/1/edit
  def edit
    @disclosure = Disclosure.find(params[:id])
  end

  # POST /disclosures
  # POST /disclosures.json
  def create
    @disclosure = Disclosure.new(params[:disclosure])

    respond_to do |format|
      if @disclosure.save
        format.html { redirect_to disclosures_path, notice: 'Disclosure was successfully created.' }
        format.json { render json: @disclosure, status: :created, location: @disclosure }
      else
        format.html { render action: "new" }
        format.json { render json: @disclosure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /disclosures/1
  # PUT /disclosures/1.json
  def update
    @disclosure = Disclosure.find(params[:id])

    respond_to do |format|
      if @disclosure.update_attributes(params[:disclosure])
        format.html { redirect_to disclosures_path, notice: 'Disclosure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @disclosure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disclosures/1
  # DELETE /disclosures/1.json
  def destroy
    @disclosure = Disclosure.unscoped.find(params[:id])
    @disclosure.destroy

    respond_to do |format|
      format.html { redirect_to disclosures_url }
      format.json { head :no_content }
    end
  end

  def restore
    @disclosure = Disclosure.unscoped.find(params[:id])
    @disclosure.restore

    respond_to do |format|
      format.html { redirect_to disclosures_url }
      format.json { head :no_content }
    end
  end
end
