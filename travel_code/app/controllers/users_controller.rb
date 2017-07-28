class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update]
    before_action :admin_user, only: :destroy

    def index
        @users = User.paginate(page: params[:page])
    end

    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        auth = env["omniauth.auth"]

        if auth
            # 如果已經註冊過的 omniauth 帳號
            # 直接做登入的動作
            if User.sign_up_check_exist? auth
                @user = User.find_by(provider: auth.provider, uid: auth.uid, email: auth.info.email)

                if @user && @user.activated?
                    log_in @user
                    remember(@user)
                    redirect_back_or @user
                else
                    message = "帳號尚未驗證，請確認你的email"
                    flash[:warning] = message
                    redirect_to root_url
                end
            else
                sign_up_with_facebook(auth)
            end

        else
            sign_up_with_password(user_params)
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])

        if @user.update_attributes(user_params)
            flash[:success] = "更新成功"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "刪除成功"
        redirect_to users_url
    end

    private
        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end

        def logged_in_user
            unless logged_in?
                store_location
                flash[:danger] = "請先登入"
                redirect_to log_in_url
            end
        end

        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_url) unless current_user?(@user)
        end

        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end

        def sign_up_with_password(user_params)
            sign_up_user User.new(user_params)
        end

        def sign_up_with_facebook(auth)
            sign_up_user User.from_fb_omniauth(auth)
        end

        def sign_up_user(user)
            @user = user
            if @user.save
                @user.send_activation_email
                flash[:info] = "請確認你的email，驗證你的帳號"
                redirect_to root_url
            else
                render 'new'
            end
        end
end
