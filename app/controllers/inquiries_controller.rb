class InquiriesController < ApplicationController
  # GET /inquiries/new
  # GET /inquiries/new.json
  def new
    @inquiry = Inquiry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inquiry }
    end
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    @inquiry = Inquiry.new(inquiry_params)
    @subscriber = @inquiry.subscriber = Subscriber.find_or_initialize_by subscriber_params
    @vehicle = Vehicle.find params[:vehicle_id]

    respond_to do |format|
      if [@inquiry.valid?, @subscriber.valid?].all?
        @inquiry.save
        @subscriber.likes @vehicle
        InquiryWorker.perform_async @inquiry.id
        format.html { redirect_to @inquiry, notice: 'Inquiry was successfully created.' }
        format.js { head :created }
      else
        format.html { render action: "new" }
        format.js do
          errors = { inquiry: @inquiry.errors, subscriber: @subscriber.errors }
          render json: errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:body, :subscriber_id, :vehicle_id, :error)
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
