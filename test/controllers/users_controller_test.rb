require 'test_helper'

class UsersControllerTest < ActionController::TestCase
    def setup
        @user = users(:test)
        @hogs = users(:hogs)
    end

    test "should get new" do
        get :new
        assert_response :success
    end

    test "should redirect edit when not logged in" do
        get :edit, id: @user
        assert_redirected_to log_in_url
    end

    test "should rediect update when not logged in" do
        patch :update, id: @user, user: { name: @user.name, email: @user.email }
        assert_redirected_to log_in_url
    end

    test "should redirect edit when logged in wrong user" do
        log_in_as(@hogs)
        get :edit, id: @user
        assert_redirected_to root_url
    end

    test "should redirect update when logged in wrong user" do
        log_in_as(@hogs)
        patch :update, id: @user, user: { name: @user.name, email: @user.email }
        assert_redirected_to root_url
    end

    test "should redirect index when not logged in" do
        get :index
        assert_redirected_to log_in_url
    end
end
