require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  test "discount attributes must not be empty" do
    discount = Discount.new
    assert discount.invalid?
    assert discount.errors[:titulo].any?
    assert discount.errors[:precio].any?
    assert discount.errors[:vencimiento].any?
    assert discount.errors[:equipment_id].any?
  end

  test "discount price must be positive" do
	discount = Discount.new(titulo:"My Book Title",
							vencimiento: 2014-06-27,
							equipment_id: 1)
	discount.precio = -1
	assert discount.invalid?
	assert_equal ["must be greater than or equal to 0.01"], discount.errors[:precio]
	discount.precio = 0
	assert discount.invalid?
	assert_equal ["must be greater than or equal to 0.01"], discount.errors[:precio]
	discount.precio = 1
	assert discount.valid?
  end

  	test "discount is not valid without a unique title" do
		discount = Discount.new(titulo:     	 "primerdescuento",
			        			precio: 		 9,
								vencimiento:	 2014-06-26,
								equipment_id:    298486374)
		assert discount.invalid?
		assert_equal ["ya existe"], discount.errors[:titulo]
	end

end
