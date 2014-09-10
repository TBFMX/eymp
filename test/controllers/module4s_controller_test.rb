require 'test_helper'

class Module4sControllerTest < ActionController::TestCase
  setup do
    @module4 = module4s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:module4s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create module4" do
    assert_difference('Module4.count') do
      post :create, module4: { name: @module4.name }
    end

    assert_redirected_to module4_path(assigns(:module4))
  end

  test "should show module4" do
    get :show, id: @module4
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @module4
    assert_response :success
  end

  test "should update module4" do
    patch :update, id: @module4, module4: { name: @module4.name }
    assert_redirected_to module4_path(assigns(:module4))
  end

  test "should destroy module4" do
    assert_difference('Module4.count', -1) do
      delete :destroy, id: @module4
    end

    assert_redirected_to module4s_path
  end
end
