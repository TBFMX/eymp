require 'test_helper'

class Module1sControllerTest < ActionController::TestCase
  setup do
    @module1 = module1s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:module1s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create module1" do
    assert_difference('Module1.count') do
      post :create, module1: { name: @module1.name }
    end

    assert_redirected_to module1_path(assigns(:module1))
  end

  test "should show module1" do
    get :show, id: @module1
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @module1
    assert_response :success
  end

  test "should update module1" do
    patch :update, id: @module1, module1: { name: @module1.name }
    assert_redirected_to module1_path(assigns(:module1))
  end

  test "should destroy module1" do
    assert_difference('Module1.count', -1) do
      delete :destroy, id: @module1
    end

    assert_redirected_to module1s_path
  end
end
