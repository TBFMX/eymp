require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase
  test "equipment attributes must not be empty" do
	equipment = Equipment.new
	assert equipment.invalid?
	assert equipment.errors[:name].any?
	assert equipment.errors[:currency_id].any?
	assert equipment.errors[:modelo].any?
	assert equipment.errors[:state_id].any?
	assert equipment.errors[:brand_id].any?
	assert equipment.errors[:country_id].any?
	assert equipment.errors[:publication_type].any?
	assert equipment.errors[:category_id].any?
	assert equipment.errors[:ciudad].any?
	assert equipment.errors[:precio].any?
	#assert equipment.errors[:description].any?
  end

  test "equipment price must be positive" do
	equipment = Equipment.new(name:"My Book Title",
							  currency_id: 1,
							  modelo: 1,
							  state_id: 1,
							  brand_id: 1,
							  country_id: 1,
							  publication_type: 1,
							  category_id: 1,
							  ciudad: "1",
							  precio: 10)
	equipment.precio = -1
	assert equipment.invalid?
	assert_equal ["must be greater than or equal to 0.01"], equipment.errors[:precio]
	equipment.precio = 0
	assert equipment.invalid?
	assert_equal ["must be greater than or equal to 0.01"], equipment.errors[:precio]
	equipment.precio = 1
	assert equipment.valid?
  end

  test "should not equipment post without name" do
  	equipment = Equipment.new
  	assert_not equipment.save, "Save without name"
  end

	test "equipment is not valid without a unique title" do
		equipment = Equipment.new(name: "MyString",
							  	  currency_id: 1,
							  	  modelo: 1,
							  	  state_id: 1,
							  	  brand_id: 1,
							  	  country_id: 1,
							  	  publication_type: 1,
							  	  category_id: 1,
							  	  ciudad: "1",
							  	  precio: 10)
		assert equipment.invalid?
		assert_equal ["ya existe"], equipment.errors[:name]
	end

end