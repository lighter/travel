class AttractionsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :edit, :update, :destroy]
  # before_action :correct_user, only: [:edit, :update]

  before_action :set_return_to, only: [:new, :edit]
  before_action :check_file_item_number, only: [:create, :update]

  def index
    @attractions = Attraction.paginate(page: params[:page])
  end

  def new
    @attractions = Attraction.new
    @attraction_photos = @attractions.attraction_photos.build
  end

  def create
    @attractions = current_user.attractions.build(attraction_params)

    if @attractions.save
      params[:attraction_photos]['photo'].each do |photo|
        @attraction_photos = @attractions.attraction_photos.create!(:photo => photo)
      end

      flash[:success] = "新增成功"
      redirect_to attractions_path
    else
      flash[:danger] = @attractions.errors.full_messages
      render action: :new
    end
  end

  def edit
    @attraction = Attraction.find(edit_attraction_params[:id])
    # @attraction_photos = @attraction.attraction_photos.new
  end

  def update
    @attraction = Attraction.find(params[:id])

    @attraction.attraction_photos.each do |photo|
      photo.soft_delete
    end

    if @attraction.update_attributes(attraction_params)

      params[:attraction_photos]['photo'].each do |a|
        @attraction_photos = @attraction.attraction_photos.create!(:photo => a)
      end
      
      flash[:success] = "更新成功"
      redirect_to attractions_path
    else
      flash[:danger] = @attraction.errors.full_messages
      render action: :edit
    end
  end

  def destroy
    if Attraction.find(delete_attraction_params[:id]).soft_delete                                                                                        ``
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
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :category_id, attraction_photos_attributes: [:id, :attraction_id, :photo])
  end

  def edit_attraction_params
    params.permit(:id)
  end

  def delete_attraction_params
    flash[:danger] =
    params.permit(:id)
  end

  def check_file_item_number
    if params[:attraction_photos]['photo'].count > 5
      flash[:danger] = '最多5個檔案'
      go_return_to
    end
  end

  def set_return_to
    session[:return_to] ||= request.referer
  end

  def go_return_to
    redirect_to session.delete(:return_to)
  end
end
