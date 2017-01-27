class SessionsController < ApplicationController
    def new
    end

    def create
        @user = User.find_by(email: params[:session][:email].downcase)

        # log in success
        if @user && @user.authenticate(params[:session][:password])

            # log in user
            log_in @user

            # remember user
            params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)

            redirect_to @user
        else
            flash.now[:danger] = '密碼或帳號錯誤'
            render 'new'
        end
    end

    def destroy
        log_out if logged_in?
        redirect_to root_url
    end
end
