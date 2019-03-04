class SubscribersController < ApplicationController
  before_action :require_user, except: [:cancel, :confirm, :add_to, :set_subscription_plan, :create, :search]
  # GET /subscribers
  # GET /subscribers.json
  def index
    @subscribers = Subscriber.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscribers }
    end
  end

  # GET /subscribers/1
  # GET /subscribers/1.json
  def show
    @subscriber = Subscriber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscriber }
    end
  end

  # GET /subscribers/new
  # GET /subscribers/new.json
  def new
    @subscriber = Subscriber.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscriber }
    end
  end

  # GET /subscribers/1/edit
  def edit
    @subscriber = Subscriber.find(params[:id])
  end

  # POST /subscribers
  # POST /subscribers.json
  def create
    @subscriber = Subscriber.find_or_initialize_by subscriber_params
    @vehicle = Vehicle.where(params[:vehicle]).first

    respond_to do |format|
      if @subscriber.save
        @subscriber.likes @vehicle
        mixpanel.track @subscriber.id, 'Vehicle subscriber', mixpanel_data
        format.html { redirect_to @subscriber, notice: 'Subscriber was successfully created.' }
        format.js { render nothing: true, status: :created }
      else
        format.html { render action: "new" }
        format.js { render json: {subscriber: @subscriber.errors}, status: :unprocessable_entity }
      end
    end
  end

  def search
    if params[:email]
      @subscriber = Subscriber.find_by email: params[:email]
    end
    respond_to do |format|
      format.js do
        if @subscriber
          render json: @subscriber.search_results
        else
          render nothing: true, status: :unprocessable_entity
        end
      end
    end
  end

  # PUT /subscribers/1
  # PUT /subscribers/1.json
  def update
    @subscriber = Subscriber.find(params[:id])
    respond_to do |format|
      if @subscriber.update_attributes(subscriber_params)
        if session[:subscriber]
          session[:subscriber] = nil
          format.html { redirect_to root_path, notice: 'Thanks for adding more info! We\'ll get back to you soon.'}
        else
          format.html { redirect_to @subscriber, notice: 'Subscriber was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: (session[:subscriber] ? :add_to : :edit ) }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribers/1
  # DELETE /subscribers/1.json
  def destroy
    @subscriber = Subscriber.find(params[:id])
    @subscriber.destroy

    respond_to do |format|
      format.html { redirect_to subscribers_url }
      format.json { head :no_content }
    end
  end

  # TODO: Merge these two methods gracefully
  def set_subscription_plan
    @subscriber = Subscriber.find_by token: params[:token]
    if @subscriber
      @subscriber.plan = params[:plan]
      render 'changes_saved'
    else
      redirect_to root_path, notice: 'Could not locate your subscription.'
    end
  end

  def subscribe
    @subscriber = Subscriber.find_by token: params[:id]
    if @subscriber
      @subscriber.plan = 'weekly' unless @subscriber.subscription_plan == 'daily'
      if params[:mps] and @subscriber.source.blank?
        @subscriber.source = params[:mps]
        @subscriber.save
      end
      render 'changes_saved'
    else
      redirect_to root_path, notice: 'Could not locate your subscription.'
    end
  end

  def cancel
    if @subscriber = Subscriber.find_by token: params[:id]
      @subscriber.cancel!
    else
      redirect_to root_path, notice: 'Could not locate your subscription account.  Please email us if you continue to have trouble.'
    end
  end

  def confirm
    @subscriber = Subscriber.find_by token: params[:code]
    if @subscriber
      @subscriber.confirm
      session[:subscriber] = @subscriber.token
      redirect_to add_to_subscriber_path(@subscriber)
    else
      redirect_to root_path, notice: 'That code is no longer valid.'
    end
  end

  def add_to
    @subscriber = Subscriber.find(params[:id])
    if session[:subscriber] and session[:subscriber] == @subscriber.token
      @page = Page.find(16) # tell-us-more as defined by seeds.rb
    else
      redirect_to root_path, notice: 'It doesn\'t look like you\'re the subscriber you\'re trying to update.'
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :token,
      :confirmed?,
      :subscription_plan,
      :opted_in_at,
      :source,
      :profit
    )
  end
end
