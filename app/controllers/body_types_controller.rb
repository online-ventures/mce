class BodyTypesController < ApplicationController
	# GET /body_types
	# GET /body_types.json
	def index
		if params[:deleted] and params[:deleted] == 'true'
			@body_types = BodyType.unscoped.where('deleted_at IS NOT NULL').order(:id).all
		else
			@body_types = BodyType.order(:id).all
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @body_types }
		end
	end

	# GET /body_types/1
	# GET /body_types/1.json
	def show
		respond_to do |format|
			format.html { redirect_to body_types_path }
			format.json { render json: BodyType.find(params[:id]) }
		end
	end

	# GET /body_types/new
	# GET /body_types/new.json
	def new
		@body_type = BodyType.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @body_type }
		end
	end

	# GET /body_types/1/edit
	def edit
		@body_type = BodyType.find(params[:id])
	end

	# POST /body_types
	# POST /body_types.json
	def create
		@body_type = BodyType.new(params[:body_type])

		respond_to do |format|
			if @body_type.save
				format.html { redirect_to body_types_path, notice: 'Body type was successfully created.' }
				format.json { render json: @body_type, status: :created, location: @body_type }
			else
				format.html { render action: "new" }
				format.json { render json: @body_type.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /body_types/1
	# PUT /body_types/1.json
	def update
		@body_type = BodyType.find(params[:id])

		respond_to do |format|
			if @body_type.update_attributes(params[:body_type])
				format.html { redirect_to body_types_path, notice: 'Body type was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @body_type.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /body_types/1
	# DELETE /body_types/1.json
	def destroy
		@body_type = BodyType.unscoped.find(params[:id])
		@body_type.destroy

		respond_to do |format|
			format.html { redirect_to body_types_url }
			format.json { head :no_content }
		end
	end

	def restore
		@body_type = BodyType.unscoped.find(params[:id])
		@body_type.restore

		respond_to do |format|
			format.html { redirect_to body_types_url }
			format.json { head :no_content }
		end
	end
end
