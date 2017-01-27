require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:test)
    end

    test "login with invalid information" do
        get log_in_path
        assert_template 'sessions/new'

        post log_in_path, session: { email: "", password: "" }
        assert_template 'sessions/new'
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end

    test "login with valid information" do
        get log_in_path
        post log_in_path, session: { email: @user.email, password: "abcd1234" }

        # check log in rediect is corrected
        assert_redirected_to @user

        # go to redirect url
        follow_redirect!

        assert_template 'users/show'
        assert_select "a[href=?]", log_in_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
    end

    test "login with valid information followed by logout" do
        get log_in_path
        post log_in_path, session: { email: @user.email, password: "abcd1234" }

        # check is logged in
        assert is_logged_in?

        assert_redirected_to @user
        follow_redirect!

        assert_template 'users/show'
        assert_select "a[href=?]", log_in_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)

        # logout
        delete logout_path

        # check is logged in
        assert_not is_logged_in?
        assert_redirected_to root_url

        # simulation logout on the other window
        delete logout_path

        follow_redirect!
        assert_select "a[href=?]", log_in_path
        assert_select "a[href=?]", logout_path, count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
    end

    test "log in with remember_me" do
        log_in_as(@user, remember_me: '1')

        # 測試中的@user沒有 remember_token 這個 symbol
        #assert_not_nil cookies['remember_token']

        assert_equal assigns(:user).remember_token, cookies['remember_token']
    end

    test "log in without remember_me" do
        log_in_as(@user, remember_me: '0')

        assert_nil cookies['remember_token']
    end
end
