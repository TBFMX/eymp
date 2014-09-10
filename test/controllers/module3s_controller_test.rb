require 'test_helper'

class Module3sControllerTest < ActionController::TestCase
  setup do
    @module3 = module3s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:module3s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create module3" do
    assert_difference('Module3.count') do
      post :create, module3: { name: @module3.name }
    end

    assert_redirected_to module3_path(assigns(:module3))
  end

  test "should show module3" do
    get :show, id: @module3
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @module3
    assert_response :success
  end

  test "should update module3" do
    patch :update, id: @module3, module3: { name: @module3.name }
    assert_redirected_to module3_path(assigns(:module3))
  end

  test "should destroy module3" do
    assert_difference('Module3.count', -1) do
      delete :destroy, id: @module3
    end

    assert_redirected_to module3s_path
  end
end
