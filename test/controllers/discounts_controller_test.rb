require 'test_helper'

class DiscountsControllerTest < ActionController::TestCase
  setup do
    @discount = discounts(:one)
    @update = {
      titulo:       'holaholahola',
      precio:       9.99,
      vencimiento:  2014-06-27,
      equipment_id: 298486374
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discount" do
    assert_difference('Discount.count') do
      post :create, discount: @update
      #post :create, discount: { equipment_id: @discount.equipment_id, precio: @discount.precio, titulo: @discount.titulo, vencimiento: @discount.vencimiento }
    end

    assert_redirected_to discount_path(assigns(:discount))
  end

  test "should show discount" do
    get :show, id: @discount
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discount
    assert_response :success
  end

  test "should update discount" do
    patch :update, id: @discount, discount: { equipment_id: @discount.equipment_id, precio: @discount.precio, titulo: @discount.titulo, vencimiento: @discount.vencimiento }
    assert_redirected_to discount_path(assigns(:discount))
  end

  test "should destroy discount" do
    assert_difference('Discount.count', -1) do
      delete :destroy, id: @discount
    end

    assert_redirected_to discounts_path
  end
end
