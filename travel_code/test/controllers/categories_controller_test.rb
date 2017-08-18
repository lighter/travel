require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def setup
     @food = categories(:food)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
end
