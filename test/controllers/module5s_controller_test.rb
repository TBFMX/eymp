require 'test_helper'

class Module5sControllerTest < ActionController::TestCase
  setup do
    @module5 = module5s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:module5s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create module5" do
    assert_difference('Module5.count') do
      post :create, module5: { name: @module5.name }
    end

    assert_redirected_to module5_path(assigns(:module5))
  end

  test "should show module5" do
    get :show, id: @module5
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @module5
    assert_response :success
  end

  test "should update module5" do
    patch :update, id: @module5, module5: { name: @module5.name }
    assert_redirected_to module5_path(assigns(:module5))
  end

  test "should destroy module5" do
    assert_difference('Module5.count', -1) do
      delete :destroy, id: @module5
    end

    assert_redirected_to module5s_path
  end
end
