class AttractionsController < ApplicationController
  def index
    @attractions = Attraction.all
  end

  def new
    @attractions = Attraction.new
  end

  def create
    post_params = attraction_params

    @attractions = current_user.attractions.build(post_params)

    if @attractions.save
      render :text => 'ok'
    else
      render :text => 'not ok'
    end
  end

  def edit
    @attraction = Attraction.find(edit_attraction_params[:id])
  end

  private

  def attraction_params
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :type)
  end

  def edit_attraction_params
    params.permit(:id)
  end
end
