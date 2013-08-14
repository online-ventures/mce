require 'test_helper'

class DisclosuresControllerTest < ActionController::TestCase
  setup do
    @disclosure = disclosures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disclosures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disclosure" do
    assert_difference('Disclosure.count') do
      post :create, disclosure: { body: @disclosure.body, deleted_at: @disclosure.deleted_at, name: @disclosure.name }
    end

    assert_redirected_to disclosure_path(assigns(:disclosure))
  end

  test "should show disclosure" do
    get :show, id: @disclosure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @disclosure
    assert_response :success
  end

  test "should update disclosure" do
    put :update, id: @disclosure, disclosure: { body: @disclosure.body, deleted_at: @disclosure.deleted_at, name: @disclosure.name }
    assert_redirected_to disclosure_path(assigns(:disclosure))
  end

  test "should destroy disclosure" do
    assert_difference('Disclosure.count', -1) do
      delete :destroy, id: @disclosure
    end

    assert_redirected_to disclosures_path
  end
end
