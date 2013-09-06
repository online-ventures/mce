module ApplicationHelper

	# Extend time classes
	time_class = lambda do |a|
		def short
			self.strftime '%b %e, %Y'
		end

		def long
			self.strftime '%B %e, %Y'
		end

		def weekday
			self.strftime '%A'
		end
	end
	Time.class_eval &time_class
	DateTime.class_eval &time_class

	# Return the interpolated template text if the variable has a value.
	# http://stackoverflow.com/a/1697919/1893290
	#
	# show_if " updated $1 ago.", time_ago_in_words(@vehicle.updated_at), @vehicle.updated_at != @vehicle.created_at
	#
	# > " Updated 12 days ago."
	#
	def show_if(template, variable, condition = nil, &block)
		# if no condition, use variable, optionally, use condition instead
		if (condition.nil? && variable) || (!condition.nil? && !!condition)
			# if we pass a block, give that instead
			if block_given?
				yield block
			elsif template.match /\$1/
				raw template.gsub('$1', variable)
			end
		else
			''
		end
	end

	def index_title_helper
		klass = eval(params[:controller].classify)
		raw "<h1>Listing #{'Deleted' if params[:deleted] and params[:deleted] == 'true'} #{klass.to_s.pluralize.capitalize}</h1>"
	end

	def new_record_button(klass)
		link_to "New #{klass.to_s.humanize}", eval("new_#{klass.to_s.tableize.singularize}_path"), class: 'button'
	end

	def toggle_deleted_view_button(klass)
		if klass.unscoped.where('deleted_at IS NOT NULL').count > 0
			if params[:deleted] and params[:deleted] == 'true'
				link_to "Show Active #{klass.to_s.pluralize}", eval("#{klass.to_s.tableize}_path"), class: 'button right'
			else
				link_to "Show Deactivated #{klass.to_s.pluralize}", '?deleted=true', class: 'button right'
			end
		end
	end

	def new_and_toggle_buttons
		klass = eval(params[:controller].classify)
		"<div class='row'>
      <div class='large-3 columns'>
        #{new_record_button(klass)}
      </div>
      <div class='large-4 columns'>
        #{toggle_deleted_view_button(klass)}
      </div>
    </div>".html_safe
	end

	def manage_buttons(record)
		output = ''
		if params[:deleted] and params[:deleted] == 'true'
			output << link_to('Reactivate', eval("restore_#{record.class.to_s.downcase}_path(record)"), method: :put, class: 'small success button')
		else
			output << link_to('Edit', eval("edit_#{record.class.to_s.tableize.singularize}_path(record)"), class: 'small secondary button')
			output << link_to('Deactivate', record, method: :delete, data: {confirm: 'Are you sure?'}, class: 'small alert button')
		end
		raw output
	end
end
