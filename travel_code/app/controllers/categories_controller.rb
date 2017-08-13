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
      redirect_to categories_path
    else
      render :text => 'not ok'
    end
  end

  def destroy
    if Category.find(delete_category_params[:id]).soft_delete
      render text: 'ok'
    else
      render text: 'not ok'
    end
  end

  def edit
    @category = Category.find(edit_category_params[:id])
  end

  def update
    @category = Category.find(params[:id])

    @category.name = update_category_params[:name]

    if @category.save
      redirect_to categories_path
    else
      render text: 'not ok'
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

  def update_category_params
    params.require(:category).permit(:name)
  end
end
