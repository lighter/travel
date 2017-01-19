require 'test_helper'

class UsersSingupTest < ActionDispatch::IntegrationTest
    test "invalid sign_up information" do
        get sign_up_users_path
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
        get sign_up_users_path

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

        assert_template 'users/show'
        assert_not flash.empty?
    end
end
