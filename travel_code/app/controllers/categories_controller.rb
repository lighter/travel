class CategoriesController < ApplicationController
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
    if Category.find(delete_category_params[:id]).soft_delete
      flash[:success] = "刪除成功"
    else
      flash[:danger] = "刪除失敗"
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
end
