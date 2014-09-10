require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @update = {
      username:   'holahola',
      password:   'hola1212',
      email:      'holahola@hola.com',
      name:       'hola',
      lastname:   'hola',
      rol_id:     298486374
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @update
      #post :create, user: { email: @user.email, lastname: @user.lastname, name: @user.name, password_digest: @user.password_digest, rol_id: @user.rol_id, username: @user.username }
      #post :create, user: { email: @user.email, lastname: @user.lastname, login_date: @user.login_date, name: @user.name, password: 'secret', password_confirmation: 'secret', password_date: @user.password_date, rol_id: @user.rol_id, username: @user.username }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { username: @user.username, password: @user.password, email: @user.email, name: @user.name, lastname: @user.lastname, rol_id: @user.rol_id}
    #patch :update, id: @user, user: { email: @user.email, lastname: @user.lastname, login_date: @user.login_date, name: @user.name, password: 'secret', password_confirmation: 'secret', password_date: @user.password_date, rol_id: @user.rol_id, username: @user.username }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
