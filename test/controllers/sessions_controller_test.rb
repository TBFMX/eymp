require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  #test "should log in" do
    #User.stubs(:authenticate).returns true
    #assert_response :success
  #end

  #test "should get create" do
    #get :create
    #assert_response :success
  #end

  #test "should get destroy" do
    #get :destroy
    #assert_response :success
  #end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    dave = users(:three)
    post :create, uname: dave.username, password: 'demo12'
    assert_redirected_to root_url
    assert_equal dave.id, session[:user_id]
  end

  test "should fail login" do
    dave = users(:one)
    post :create, uname: dave.username, password: 'wrong'
    assert_redirected_to root_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to root_url
  end

end
