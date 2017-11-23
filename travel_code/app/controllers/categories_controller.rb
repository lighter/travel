class CategoriesController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :edit, :update, :destroy]
  before_action :is_owner, only: [:edit, :update]
  before_action :admin_user

  def index
    @categories = Category.paginate(page: params[:page], per_page: 10)
  end

  def new
    @categories = Category.new
  end

  def create
    @categories = current_user.categories.new(category_params)

    if @categories.save
      flash[:success] = "新增成功"
      redirect_to categories_path
    else
      flash[:danger] = @categories.errors.full_messages
      render action: :new
    end
  end

  def destroy
    @category = Category.find_by(id: delete_category_params[:id])
    if !@category.nil?
      if @category.soft_delete
        flash[:success] = "刪除成功"
      else
        flash[:danger] = "刪除失敗"
      end
    else
      flash[:danger] = "該筆資料不存在"
    end
    redirect_to categories_path
  end

  def edit
    @category = Category.find(edit_category_params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      flash[:success] = "更新成功"
      redirect_to categories_path
    else
      flash[:danger] = @category.errors.full_messages
      render action: :edit
    end

  end


  private

  def category_params
    params.require(:category).permit(:name)
  end

  def delete_category_params
    params.permit(:id)
  end

  def edit_category_params
    params.permit(:id)
  end

  def is_owner
    category = Category.find(params[:id])
    redirect_to(root_url) unless category.user === current_user
  end
end
