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
end
