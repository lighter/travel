class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index, :edit, :update]
    before_action :correct_user, only: [:edit, :update]

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
        @user = User.new(user_params)

        if @user.save
            # sign_up with sign_in
            log_in @user

            flash[:success] = "Welcome!"

            redirect_to @user
        else
            render 'new'
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
end
