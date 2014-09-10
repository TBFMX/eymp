require 'test_helper'

class RolTest < ActiveSupport::TestCase
  test "rol attributes must not be empty" do
    rol = Rol.new
    assert rol.invalid?
    assert rol.errors[:rol_name].any?
  end
end
