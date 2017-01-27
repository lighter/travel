ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # check logged in
    def is_logged_in?
        !session[:user_id].nil?
    end

    # log in test, 避免重複的 log in test code
    def log_in_as(user, options = {})
        password = options[:password] || 'abcd1234'
        remember_me = options[:remember_me] || '1'

        if integration_test?
            post log_in_path, session: {
                email: user.email,
                password: password,
                remember_me: remember_me
            }
        else
            session[:user_id] = user.id
        end
    end

    private

        def integration_test?
            defined?(post_via_redirect) # post_via_redirect 發起 HTTP POSt 並跟蹤後續導向
        end
end
