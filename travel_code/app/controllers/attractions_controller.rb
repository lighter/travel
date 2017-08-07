class AttractionsController < ApplicationController
  def index
    @attractions = Attraction.all
  end

  def new
    @attractions = Attraction.new
  end

  def create
    post_params = attraction_params
    post_params[:address] = "#{post_params[:address]}@@#{post_params[:country]}"

    @attractions = current_user.attractions.build(post_params)

    if @attractions.save
      render :text => 'ok'
    else
      render :text => 'not ok'
    end
  end

  private

  def attraction_params
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :country)
  end
end
