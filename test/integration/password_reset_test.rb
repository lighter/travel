require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
    def setup
        ActionMailer::Base::deliveries.clear
        @user = users(:test)
    end

    test "password reset" do
        get new_password_reset_path
        assert_template 'password_reset/new'

        # email isn't work
        post password_reset_index_path, password_reset: { email: "" }
        assert_not flash.empty?
        assert_template 'password_reset/new'

        # email is work
        post password_reset_index_path, password_reset: { email: @user.email }
        assert_not_equal @user.reset_digest, @user.reload.reset_digest
        assert_equal 1, ActionMailer::Base::deliveries.size
        assert_not flash.empty?
        assert_redirected_to root_url

        # password reset
        user = assigns(:user)

        # email link is wrong
        get edit_password_reset_path(user.reset_token, email: "")
        assert_redirected_to root_url

        # user not verification
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_redirected_to root_url
        user.toggle!(:activated)

        # email 正確，驗證碼錯誤
        get edit_password_reset_path('wrong token', email: user.email)
        assert_redirected_to root_url

        # email，驗證碼都正確
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_template 'password_reset/edit'
        assert_select 'input[name=email][type=hidden][value=?]', user.email

        # password, password_confirmation are wrong
        patch password_reset_path(user.reset_token), email: user.email,
                                                     user: { password: 'test', password_confirmation: '1234' }
        assert_select 'div#error_explanation'

        # password is empty
        patch password_reset_path(user.reset_token), email: user.email,
                                                     user: { password: '', password_confirmation: '' }
        assert_not flash.empty?
        assert_template 'password_reset/edit'

        # password, password_confirmation are correct
        patch password_reset_path(user.reset_token), email: user.email,
                                                     user: { password: 'test1234', password_confirmation: 'test1234' }
        assert is_logged_in?
        assert_not flash.empty?
        assert_redirected_to user
    end

    test "expired token" do
        get new_password_reset_path
        post password_reset_index_path, password_reset: { email: @user.email }

        @user = assigns(:user)
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@user.reset_token), email: @user.email, user: { password: "test1234", password_confirmation: "test1234" }

        assert_response :redirect
        follow_redirect!
        assert_match /忘記密碼/i, response.body
    end
end
