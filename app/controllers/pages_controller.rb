class PagesController < ApplicationController
  require 'rdiscount'
  before_action :require_user, except: %i[show home]
  before_action :require_user, if: proc { params[:slug].in? %w[members] }
  before_action :set_page, only: %i[show edit update destroy restore]

  # GET /pages
  # GET /pages.json
  def index
    @pages = if params[:deleted] && (params[:deleted] == 'true')
               Page.deleted
             else
               Page.alive.order('active DESC, id').all
             end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    respond_to do |format|
      # Try to render view, and if that fails, render generic version
      format.html do
        render "pages/#{params[:slug] || @page.slug}"
      rescue ActionView::MissingTemplate
        render 'pages/show'
      end
      format.json { render json: @page }
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
  def edit; end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to slug_path(@page.slug), notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to slug_path(@page.slug), notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  def restore
    @page.restore
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private

  def set_page
    @page = !!!current_user ? Page.active : Page
    if params[:id]
      @page = @page.where(id: params[:id].to_i).first
    elsif params[:slug]
      @page = @page.where(slug: params[:slug]).first
    end
    not_found if @page.blank? && !has_view?
  end

  def has_view?
    found = false
    to_search = []
    to_search << params[:slug] unless params[:slug].nil?
    to_search << @page.slug if @page.is_a?(Page)
    to_search.each do |name|
      found = true if File.exist? File.join(Rails.root, 'app/views/pages', "#{name}.html.erb")
    end
    found
  end

  def page_params
    params.require(:page).permit(:active, :body, :featured, :name, :slug)
  end
end
