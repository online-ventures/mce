class InquiriesController < ApplicationController
  # GET /inquiries
  # GET /inquiries.json
  def index
    @inquiries = Inquiry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inquiries }
    end
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
    @inquiry = Inquiry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inquiry }
    end
  end

  # GET /inquiries/new
  # GET /inquiries/new.json
  def new
    @inquiry = Inquiry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inquiry }
    end
  end

  # GET /inquiries/1/edit
  def edit
    @inquiry = Inquiry.find(params[:id])
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    @inquiry = Inquiry.new(params[:inquiry])
    @subscriber = @inquiry.subscriber = Subscriber.find_or_initialize_by_params params[:subscriber]

    respond_to do |format|
      if [@inquiry.valid?, @subscriber.valid?].all?
        @inquiry.save
        @subscriber.save_interest params[:interest]
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

  # PUT /inquiries/1
  # PUT /inquiries/1.json
  def update
    @inquiry = Inquiry.find(params[:id])

    respond_to do |format|
      if @inquiry.update_attributes(params[:inquiry])
        format.html { redirect_to @inquiry, notice: 'Inquiry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    @inquiry = Inquiry.find(params[:id])
    @inquiry.destroy

    respond_to do |format|
      format.html { redirect_to inquiries_url }
      format.json { head :no_content }
    end
  end
end
