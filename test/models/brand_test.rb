require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  test "brand attributes must not be empty" do
    brand = Brand.new
    assert brand.invalid?
    assert brand.errors[:name].any?
  end
end
