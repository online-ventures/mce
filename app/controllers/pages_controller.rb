class PagesController < ApplicationController
  require 'rdiscount'
  before_filter :require_user, except: [:show, :home, :newrelic]

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
    # ID is straightforward
    if params[:id]
      @page = Page.where(active: true).find(params[:id])
      @slug = @page.slug
    # Find by slug, and if admin, include private pages
    elsif params[:slug]
      @slug = params[:slug]
      conditions = current_user ? true : {active: true}
      @page = Page.where(conditions).find_by_slug(@slug)
    end

    # Does a view file exist for this slug?
    has_view = File.exists? File.join(Rails.root, 'app/views/pages', "#{params[:slug]||@page.slug}.html.erb")

    # If we don't have a @page, and we don't have a view, give up
    if @page.nil? and !has_view
      redirect_to root_url, notice: "That Page Doesn't Exist"
    else
      respond_to do |format|
        # Try to render view, and if that fails, render generic version
        format.html {
          begin
            render "pages/#{@slug}"
          rescue ActionView::MissingTemplate
            render "pages/show"
          end }
        format.json { render json: @page }
      end
    end
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
    Rails.cache.delete(@page)
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
    Rails.cache.delete(@page)
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  def newrelic
    if Page.find(1)
      @status = 'Application Awake'
    else
      @status = 'Error: Application Asleep'
    end
  end
end
