class AttractionsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :edit, :update, :destroy]
  # before_action :correct_user, only: [:edit, :update]

  def index
    @attractions = Attraction.paginate(page: params[:page])
  end

  def new
    @attractions = Attraction.new
    @attractions.attraction_photos.build
  end

  def create
    @attractions = current_user.attractions.build(attraction_params)

    if @attractions.save
      flash[:success] = "新增成功"
      redirect_to attractions_path
    else
      flash[:danger] = @attractions.errors.full_messages
      render action: :new
    end
  end

  def edit
    @attraction = Attraction.find(edit_attraction_params[:id])
  end

  def update
    @attraction = Attraction.find(params[:id])

    if @attraction.update_attributes(attraction_params)
      flash[:success] = "更新成功"
      redirect_to attractions_path
    else
      flash[:danger] = @attraction.errors.full_messages
      render action: :edit
    end
  end

  def destroy
    if Attraction.find(delete_attraction_params[:id]).soft_delete
      flash[:success] = "刪除成功"
    else
      flash[:success] = "刪除失敗"
    end

    redirect_to attractions_path
  end

  def search
    @attractions = Attraction
                       .where('name like ?', "%#{params[:search_name]}%")
                       .paginate(page: params[:page])

    render 'index'
  end


  private

  def attraction_params
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :category_id, attraction_photos_attributes: {photo: []})
  end

  def edit_attraction_params
    params.permit(:id)
  end

  def delete_attraction_params
    params.permit(:id)
  end
end
