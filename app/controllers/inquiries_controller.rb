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
    @inquiry = Inquiry.new(params[:inquiry])
    @subscriber = @inquiry.subscriber = Subscriber.find_or_initialize_by_params params[:subscriber]
    @vehicle = Vehicle.find params[:vehicle_id]

    respond_to do |format|
      if [@inquiry.valid?, @subscriber.valid?].all?
        @inquiry.save
        @subscriber.likes @vehicle
        mixpanel.track @subscriber.id, 'Vehicle inquiry', mixpanel_data
        format.html { redirect_to @inquiry, notice: 'Inquiry was successfully created.' }
        format.js { render nothing: true, status: :created }
      else
        format.html { render action: "new" }
        format.js do
          errors = { inquiry: @inquiry.errors, subscriber: @subscriber.errors }
          render json: errors, status: :unprocessable_entity
        end
      end
    end
  end
end
