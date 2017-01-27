require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        time = Time.now.strftime("%Y%m%d%H%M%s")
        @user = User.new(name: "test#{time}", email: "test#{time}@test.com", password: "password", password_confirmation: "password")
    end

    test "should be valid" do
        assert @user.valid?
    end

    test "name should be present" do
        @user.name = " "
        assert_not @user.valid?
    end

    test "email should be present" do
        @user.email = " "
        assert_not @user.valid?
    end

    test "name should not too long" do
        @user.name = "a" * 51
        assert_not @user.valid?
    end

    test "email should not too long" do
        @user.email = "a" * 255 + "@test.com"
        assert_not @user.valid?
    end

    test "email format" do
        valid_emails = %w[user@email,com, test,_MAIL@gmail.com, abc+123@gmail.com, www.google.com]

        valid_emails.each do |email|
            @user.email = email
            assert_not @user.valid?
        end
    end

    test "test email is uniqu" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        assert_not duplicate_user.valid?
    end

    test "password should be presen nonblank" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
    end

    test "password should have a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
        assert_not @user.authenticate?('')
    end
end
