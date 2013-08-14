require 'test_helper'

class DrivablesControllerTest < ActionController::TestCase
  setup do
    @drivable = drivables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drivables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drivable" do
    assert_difference('Drivable.count') do
      post :create, drivable: { body: @drivable.body, name: @drivable.name }
    end

    assert_redirected_to drivable_path(assigns(:drivable))
  end

  test "should show drivable" do
    get :show, id: @drivable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drivable
    assert_response :success
  end

  test "should update drivable" do
    put :update, id: @drivable, drivable: { body: @drivable.body, name: @drivable.name }
    assert_redirected_to drivable_path(assigns(:drivable))
  end

  test "should destroy drivable" do
    assert_difference('Drivable.count', -1) do
      delete :destroy, id: @drivable
    end

    assert_redirected_to drivables_path
  end
end
