require 'test_helper'

class AttractionsControllerTest < ActionController::TestCase

  def setup
    @user        = users(:test)
    @attraction1 = attractions(:attraction1)
    @attraction2 = attractions(:attraction2)
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

  test "should_get_index" do
    log_in_as(@user)
    get :index
    assert_response :success
  end

  test "should_not_get_index" do
    get :index
    assert_redirected_to log_in_url
  end

  test "should_create_success" do
    log_in_as(@user)
    post :create,
         attraction: {
             name:        'attraction',
             longitude:   12.34,
             latitude:    34.56,
             address:     'ABC Rd.',
             phone:       12345678,
             category_id: @attraction1.id }
    assert_redirected_to attractions_url
    assert_equal '新增成功', flash[:success]
  end

  test "should_create_fail" do
    log_in_as(@user)
    post :create,
         attraction: {
             name:        '',
             longitude:   12.34,
             latitude:    34.56,
             address:     'ABC Rd.',
             phone:       12345678,
             category_id: @attraction1.id }
    assert_template :new
  end

  test "should_get_edit" do
    log_in_as(@user)
    get :edit, id: @attraction1
    assert_response :success
  end

  test "should_not_get_edit" do
    log_in_as(@user)
    get :edit, id: @attraction2
    assert_redirected_to root_url
  end

  test "should_update" do
    log_in_as(@user)
    put :update, attraction: { name: 'AAAA' }, id: @attraction1.id
    assert_redirected_to attractions_path
  end

  test "should_updata_fail" do
    log_in_as(@user)
    put :update, attraction: { name: 'BBBB' }, id: @attraction2.id
    assert_redirected_to root_url
  end

  test "should_destroy_success" do
    log_in_as(@user)
    delete :destroy, id: @attraction1.id
    assert_equal '刪除成功', flash[:success]
  end

  test "should_destroy_fail" do
    log_in_as(@user)
    delete :destroy, id: @attraction2.id
    assert_redirected_to root_url
  end

  test "should_search_attraction" do
    log_in_as(@user)
    get :search_user, search_name: 'attraction'
    assert_template 'user_attraction'
  end

  test "should_favorite_attraction" do
    log_in_as(@user)
    xhr :post, :favorite, id: @attraction1.id

    body = JSON.parse(response.body)
    assert_equal "true", body['status']
  end

  test "should_not_favorite_attraction" do
    log_in_as(@user)
    xhr :post, :favorite, id: 999

    body = JSON.parse(response.body)
    assert_equal "false", body['status']
  end

  test "should_unfavorite_attraction" do
    log_in_as(@user)
    xhr :post, :favorite, id: @attraction1.id

    xhr :post, :unfavorite, id: @attraction1.id

    body = JSON.parse(response.body)
    assert_equal 'true', body['status']
  end


  test "should_not_unfavorite_attraction" do
    log_in_as(@user)
    xhr :post, :unfavorite, id: 999

    body = JSON.parse(response.body)
    assert_equal 'false', body['status']
  end
end
