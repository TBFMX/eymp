require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get equipos" do
    get :equipos
    assert_response :success
  end

  test "should get gallerias" do
    get :gallerias
    assert_response :success
  end

  test "should get imagenes" do
    get :imagenes
    assert_response :success
  end

  test "should get videos" do
    get :videos
    assert_response :success
  end

end
