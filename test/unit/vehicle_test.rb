require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
	test "vehicle should only require year, make, and model" do
		vehicle = Vehicle.new
		assert !vehicle.save, "Vehicle able to save without year, make, and model"

		vehicle.year = strftime('%Y').to_i
		vehicle.model = model(:one)
		vehilce.make = make(:one)
		assert vehicle.save, "Vehicle unable to save with just year, make, and model"
	end
end
