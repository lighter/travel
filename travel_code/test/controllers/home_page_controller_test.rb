require 'test_helper'

class HomePageControllerTest < ActionController::TestCase
  def setup
    @user    = users(:test)
  end

  test "the truth" do
    get :index
    assert_response :success
  end

  test "should_ajaxGetAttraction_work" do
    log_in_as(@user)
    xhr :post, :ajaxGetAttractions, page: 1

    body = JSON.parse(response.body)

    assert_equal true, body.has_key?('data')
    assert_equal true, body.has_key?('pageInfo')
  end
end
