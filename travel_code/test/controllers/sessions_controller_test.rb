require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @user  = users(:test)
    @user2 = users(:test2)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should_create_session_successful" do
    post :create, session: { email: @user.email, password: 'abcd1234' }
    assert_redirected_to user_path(@user)
  end

  test "should_active_account" do
    post :create, session: { email: @user2.email, password: 'abcd1234' }
    assert_redirected_to root_url
  end

  test "should_not_login" do
    post :create, session: { email: @user.email, password: 'adsfjaojioa' }
    assert_equal '密碼或帳號錯誤', flash[:danger]
    assert_template :new
  end

  test "should_not_active_account" do
    post :create, session: { email: @user2.email, password: 'abcd1234' }
    assert_equal '帳號尚未驗證，請確認你的email', flash[:warning]
    assert_redirected_to root_url
  end

  test "log_out" do
    log_in_as(@user)
    delete :destroy

    assert_equal false, is_logged_in?
  end

end
