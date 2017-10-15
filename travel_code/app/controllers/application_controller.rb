class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  include SessionsHelper

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
end
