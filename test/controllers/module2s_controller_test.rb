require 'test_helper'

class Module2sControllerTest < ActionController::TestCase
  setup do
    @module2 = module2s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:module2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create module2" do
    assert_difference('Module2.count') do
      post :create, module2: { name: @module2.name }
    end

    assert_redirected_to module2_path(assigns(:module2))
  end

  test "should show module2" do
    get :show, id: @module2
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @module2
    assert_response :success
  end

  test "should update module2" do
    patch :update, id: @module2, module2: { name: @module2.name }
    assert_redirected_to module2_path(assigns(:module2))
  end

  test "should destroy module2" do
    assert_difference('Module2.count', -1) do
      delete :destroy, id: @module2
    end

    assert_redirected_to module2s_path
  end
end
