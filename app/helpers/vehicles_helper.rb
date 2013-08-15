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

	def warranty_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.warranty and !vehicle.warranty.body.blank?
			content_tag :div, class: 'title large-12 columns block' do
				"#{content_tag(:h4, 'About The Warranty', class: 'centered')}
				#{content_tag(:p, vehicle.warranty.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def title_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.title and !vehicle.title.body.blank?
			content_tag :div, class: 'title large-12 columns block' do
				"#{content_tag(:h4, 'About The Title', class: 'centered')}
				#{content_tag(:p, vehicle.title.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def drivable_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.drivable and !vehicle.drivable.body.blank?
			content_tag :div, class: 'title large-12 columns block' do
				"#{content_tag(:h4, 'About "'+vehicle.drivable.name+'"', class: 'centered')}
				#{content_tag(:p, vehicle.drivable.body, class: 'panel list row')}".html_safe
			end
		end
	end

	def vehicle_type_disclosure(vehicle=nil)
		vehicle ||= @vehicle
		if vehicle.body_type and !vehicle.body_type.body.blank?
			content_tag :div, class: 'title large-12 columns block' do
				"#{content_tag(:h4, 'About '+vehicle.body_type.name+'s', class: 'centered')}
				#{content_tag(:p, vehicle.title.body, class: 'panel list row')}".html_safe
			end
		end
	end
end
