require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    def setup
        ActionMailer::Base.deliveries.clear
    end

    test "invalid sign_up information" do
        get sign_up_path
        assert_no_difference 'User.count' do
            post users_path, user: {name: "",
                                    email: "test@test.com",
                                    password: 1234,
                                    password_confirmation: 123}
        end

        assert_template 'users/new'
        assert_select 'div#error_explanation'
        assert_select 'div.alert'
    end

    test "valid sign_up information" do
        get sign_up_path

        name = "test123"
        email = "test123@test.com"
        password = "test1234"

        assert_difference 'User.count', 1 do
            post_via_redirect users_path, user: {
                name: name,
                email: email,
                password: password,
                password_confirmation: password
            }
        end
    end

    test "valid sign up information with account activation" do
        get sign_up_path

        assert_difference 'User.count', 1 do
            post users_path, user: { name: "test",
                                     email: "test_abcd@test.com",
                                     password: "test1234",
                                     password_confirmation: "test1234"}
        end

        assert_equal 1, ActionMailer::Base.deliveries.size
        user = assigns(:user)
        assert_not user.activated?

        # before activation log in
        log_in_as(user)
        assert_not is_logged_in?

        # invalid token
        get edit_account_activation_path("invalid token")
        assert_not is_logged_in?

        # wrong email
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        assert_not is_logged_in?

        # correct
        get edit_account_activation_path(user.activation_token, email: user.email)
        assert user.reload.activated?
        follow_redirect!

        assert_template 'users/show'
        assert is_logged_in?
    end
end
