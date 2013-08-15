module VehiclesHelper
	def status(vehicle=nil)
		vehicle ||= @vehicle
		"#{'new' if vehicle.is_new?} #{vehicle.status}"
	end

	def miles(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.miles
			number_to_human(vehicle.miles, units: {unit: '', thousand: 'k'}, precision: 0).delete ' '
		end
	end

	def price(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.price
			if vehicle.price == 0
				return false
			end
			number_to_currency(vehicle.price, precision: 0)
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
end
