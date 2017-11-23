require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def setup
    @user    = users(:test)
    @food    = categories(:food)
    @clothes = categories(:clothes)
  end

  test "should get new" do
    log_in_as(@user)
    get :new
    assert_response :success
  end

  test "should_redirect_login_page_when_new_category_without_login" do
    get :new
    assert_redirected_to log_in_url
  end

  test "should_create_success" do
    log_in_as(@user)
    post :create, category: { name: 'new category' }
    assert_redirected_to categories_url
  end


  test "should_be_redirect_back_new_with_duplicate_category" do
    log_in_as(@user)
    post :create, category: { name: @food.name }
    assert_template :new
  end


  test "should_be_destroy_success" do
    log_in_as(@user)
    delete :destroy, id: @food.id
    assert_equal '刪除成功', flash[:success]
  end

  test "should_be_destroy_failed_with_not_exists_category" do
    log_in_as(@user)
    delete :destroy, id: 11
    assert_equal '該筆資料不存在', flash[:danger]
  end

  test "should_get_edit" do
    log_in_as(@user)
    get :edit, id: @food
    assert_response :success
  end

  test "should_not_edit" do
    log_in_as(@user)
    get :edit, id: @clothes
    assert_redirected_to root_url
  end

  test "should_update" do
    log_in_as(@user)
    put :update, { category: { name: 'new food' }, id: @food.id }
    assert_redirected_to categories_url
  end

  test "should_not_update" do
    log_in_as(@user)
    put :update, { category: { name: 'new clothes' }, id: @clothes.id }
    assert_redirected_to root_url
  end
end
