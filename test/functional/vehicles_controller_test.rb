require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post :create, vehicle: { burns: @vehicle.burns, damage_id: @vehicle.damage_id, description: @vehicle.description, drivable_id: @vehicle.drivable_id, ebay: @vehicle.ebay, engine: @vehicle.engine, engine_id: @vehicle.engine_id, ext_color_id: @vehicle.ext_color_id, int_color_id: @vehicle.int_color_id, interior_id: @vehicle.interior_id, make_id: @vehicle.make_id, miles: @vehicle.miles, model_id: @vehicle.model_id, paint_id: @vehicle.paint_id, price: @vehicle.price, stains: @vehicle.stains, status_id: @vehicle.status_id, stock_number: @vehicle.stock_number, subtitle: @vehicle.subtitle, suspension_id: @vehicle.suspension_id, tears: @vehicle.tears, title_id: @vehicle.title_id, trans_id: @vehicle.trans_id, vin: @vehicle.vin, warranty_id: @vehicle.warranty_id, year: @vehicle.year }
    end

    assert_redirected_to vehicle_path(assigns(:vehicle))
  end

  test "should show vehicle" do
    get :show, id: @vehicle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vehicle
    assert_response :success
  end

  test "should update vehicle" do
    put :update, id: @vehicle, vehicle: { burns: @vehicle.burns, damage_id: @vehicle.damage_id, description: @vehicle.description, drivable_id: @vehicle.drivable_id, ebay: @vehicle.ebay, engine: @vehicle.engine, engine_id: @vehicle.engine_id, ext_color_id: @vehicle.ext_color_id, int_color_id: @vehicle.int_color_id, interior_id: @vehicle.interior_id, make_id: @vehicle.make_id, miles: @vehicle.miles, model_id: @vehicle.model_id, paint_id: @vehicle.paint_id, price: @vehicle.price, stains: @vehicle.stains, status_id: @vehicle.status_id, stock_number: @vehicle.stock_number, subtitle: @vehicle.subtitle, suspension_id: @vehicle.suspension_id, tears: @vehicle.tears, title_id: @vehicle.title_id, trans_id: @vehicle.trans_id, vin: @vehicle.vin, warranty_id: @vehicle.warranty_id, year: @vehicle.year }
    assert_redirected_to vehicle_path(assigns(:vehicle))
  end

  test "should destroy vehicle" do
    assert_difference('Vehicle.count', -1) do
      delete :destroy, id: @vehicle
    end

    assert_redirected_to vehicles_path
  end
end
