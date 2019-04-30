class PurchasesController < ApplicationController
  before_action :load_vehicle

  def load_vehicle
    @vehicle = Vehicle.find params[:vehicle_id]
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
    @subscriber = Subscriber.new
    @purchase = @subscriber.purchases.build vehicle_id: params[:vehicle_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase }
    end
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @subscriber = Subscriber.find_or_initialize_by subscriber_params
    @purchase = @subscriber.purchases.build purchase_params

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to edit_vehicle_path(@vehicle), notice: 'Buyer successfully added for this vehicle.' }
        format.json { render json: @purchase, status: :created, location: @purchase }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /purchases/1/edit
  def edit
    @purchase = Purchase.find params[:id]
    @subscriber = @purchase.subscriber
  end

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find params[:id]
    @subscriber = @purchase.subscriber

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to edit_vehicle_path(@vehicle), notice: 'Buyer was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase = Purchase.find params[:id]
    @purchase.delete
    redirect_to edit_vehicle_path(@vehicle), notice: 'Purchase was successfully removed'
  end

  private

  def purchase_params
    params.require(:purchase).permit(:price, :profit, :subscriber_id, :vehicle_id, :source)
  end

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
