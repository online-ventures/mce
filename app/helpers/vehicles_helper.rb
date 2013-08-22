module VehiclesHelper
	def status(vehicle=nil)
		vehicle ||= @vehicle
		"#{'new' if vehicle.is_new?} #{vehicle.status}"
	end

	def miles(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.miles and vehicle.miles > 0
			number_to_human(vehicle.miles, units: {unit: '', thousand: 'k'}, precision: 0).delete ' '
		else
			false
		end
	end

	def price(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.price and vehicle.price > 0
			number_to_currency(vehicle.price, precision: 0)
		else
			false
		end
	end

	def damage(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.damage and vehicle.damage.name != 'None'
			vehicle.damage.name
		else
			false
		end
	end

	def stock_number(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.stock_number.blank?
			false
		else
			vehicle.stock_number
		end
	end

	def all_the_disclosures!(vehicle=nil)
		vehicle ||= @vehicle
		klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
		all_the_bodies = ''
		vehicle.disclosures.find_each do |d|
			all_the_bodies << d.body+'<br/>' unless d.body.blank?
		end
		content_tag :div, class: klass do
			"#{content_tag(:h3, 'Disclosure Agreement', class: 'centered title')}
			#{content_tag(:p, all_the_bodies.html_safe, class: 'panel list row')}".html_safe
		end
	end

	def warranty_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
		if vehicle.warranty and !vehicle.warranty.body.blank?
			content_tag :div, class: klass do
				"#{content_tag(:h3, 'About The Warranty', class: 'centered title')}
				#{content_tag(:p, vehicle.warranty.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def title_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
		if vehicle.title and !vehicle.title.body.blank?
			content_tag :div, class: klass do
				"#{content_tag(:h3, 'About The Title', class: 'centered title')}
				#{content_tag(:p, vehicle.title.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def drivable_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
		if vehicle.drivable and !vehicle.drivable.body.blank?
			content_tag :div, class: klass do
				"#{content_tag(:h3, 'About "'+vehicle.drivable.name+'"', class: 'centered title')}
				#{content_tag(:p, vehicle.drivable.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def vehicle_type_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		klass = params[:format] == 'ebay' ? 'title-box' : 'title large-12 columns block'
		if vehicle.body_type and !vehicle.body_type.body.blank?
			content_tag :div, class: klass do
				"#{content_tag(:h3, 'About '+vehicle.body_type.name+'s', class: 'centered title')}
				#{content_tag(:p, vehicle.title.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def featured_image_url(vehicle=nil)
		vehicle ||= @vehicle
		url = vehicle.featured_url
		url = asset_path('placeholder.jpg') unless url
		url
	end

	def new_banner(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.is_new?
			content_tag :span,
				'<i class="foundicon-smiley"></i>New'.html_safe,
				{ class: 'new banner',
				  data: { expires: (vehicle.created_at + 5.days).to_i } }
		end
	end

	def featured_banner(vehicle=nil)
		vehicle ||= @vehicle
		content_tag :span, '<i class="foundicon-star"></i>Featured'.html_safe, class: 'featured banner' if vehicle.featured
	end
end
