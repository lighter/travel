require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: 'test category', user_id: 1)
  end

  test "should be valid" do
    assert @category.valid?
  end

  test "name should be present" do
    @category.name = " "
    assert_not @category.valid?
  end

  test "name should not too long" do
    @category.name = "a" * 255
    assert_not @category.valid?
  end
end
