class PagesController < ApplicationController
  before_filter :require_user, except: [:show, :home]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    if params[:id]
      @page = Page.where(active: true).find(params[:id])
    elsif params[:slug]
      conds = current_user ? true : {active: true}
      @page = Page.where(conds).find_by_slug(params[:slug])

    end
    if @page.nil?
      redirect_to root_url, notice: "That Page Doesn't Exist"
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @page }
      end
    end
  end

  def home
    @page = Page.where(slug: 'home').first
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to slug_path(@page.slug), notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  def members

  end
end
