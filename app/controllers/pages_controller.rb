class PagesController < ApplicationController
  require 'rdiscount'
  before_action :require_user, except: [:show, :home]
  before_action :require_user, if: Proc.new() { params[:slug].in? %w(members) }
  before_action :set_page, only: [:show, :edit, :update, :destroy, :restore]

  # GET /pages
  # GET /pages.json
  def index
    if params[:deleted] and params[:deleted] == 'true'
      @pages = Page.unscoped.where('deleted_at IS NOT NULL')
    else
      @pages = Page.order('active DESC, id').all
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
      format.html {
        begin
          render "pages/#{params[:slug] || @page.slug}"
        rescue ActionView::MissingTemplate
          render "pages/show"
        end }
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
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to slug_path(@page.slug), notice: 'Page was successfully created.' }
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
    respond_to do |format|
      if @page.update_attributes(page_params)
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
    @page = !!!current_user ? Page.active : Page.unscoped
    if params[:id]
      @page = @page.where(id: params[:id].to_i).first
    elsif params[:slug]
      @page = @page.where(slug: params[:slug]).first
    end
    not_found if @page.blank?
  end

  def page_params
    params.require(:page).permit(:active, :body, :featured, :name, :slug)
  end
end
