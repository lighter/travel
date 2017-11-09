class AttractionsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :edit, :update, :destroy]
  before_action :is_owner, only: [:edit, :update]

  before_action :set_return_to, only: [:new, :edit]
  before_action :check_file_item_number, only: [:create, :update]

  def index
    @attractions = Attraction.paginate(page: params[:page])
  end

  def user_attraction
    @attractions = Attraction.where(user_id: current_user.id).paginate(page: params[:page])
  end

  def new
    @attractions       = Attraction.new
    @attraction_photos = @attractions.attraction_photos.build
  end

  def show
    @attraction = Attraction.find(params[:id])
  end

  def create
    @attractions = current_user.attractions.build(attraction_params)

    if @attractions.save
      if (params.has_key?(:attraction_photos) && params[:attraction_photos].any?)
        params[:attraction_photos]['photo'].each do |photo|
          @attraction_photos = @attractions.attraction_photos.create!(:photo => photo)
        end
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
    if Attraction.find(delete_attraction_params[:id]).soft_delete ``
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

  def search_user
    @attractions = Attraction.where('user_id = :user_id AND name like :search_name', {user_id: current_user.id, search_name: params[:search_name]}).paginate(page: params[:page])

    render 'user_attraction'
  end

  def favorite
    @attraction = Attraction.find(params[:id])
    result      = current_user.favorite(@attraction)


    respond_to do |format|
      format.json { render json: { status: result.save.to_s, id: params[:id] } }
    end
  end

  def unfavorite
    @attraction = Attraction.find(params[:id])
    result      = current_user.unfavorite(@attraction)

    respond_to do |format|
      format.json { render json: { status: result.save.to_s, id: params[:id] } }
    end
  end


  private

  def attraction_params
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :category_id, attraction_photos_attributes: [:id, :attraction_id, :photo])
  end

  def edit_attraction_params
    params.permit(:id)
  end

  def delete_attraction_params
    params.permit(:id)
  end

  def check_file_item_number
    if params.has_key?(:attraction_photos)
      if params[:attraction_photos]['photo'].count > 5
        flash[:danger] = '最多5個檔案'
        go_return_to
      end
    end
  end

  def set_return_to
    session[:return_to] ||= request.referer
  end

  def go_return_to
    redirect_to session.delete(:return_to)
  end

  def is_owner
    attraction = Attraction.find(params[:id])
    redirect_to(root_url) unless attraction.user === current_user
  end
end
