class AttractionsController < ApplicationController
  def index
    @attractions = Attraction.all
  end

  def new
    @attractions = Attraction.new
  end

  def create
    @attractions = current_user.attractions.build(attraction_params)

    if @attractions.save
      redirect_to attractions_path
    else
      render text: 'not ok'
    end
  end

  def edit
    @attraction = Attraction.find(edit_attraction_params[:id])
  end

  def update
    @attraction = Attraction.find(params[:id])

    if @attraction.update_attributes(attraction_params)
      redirect_to attractions_path
    else
      render text: 'not ok'
    end
  end

  def destroy
    if Attraction.find(delete_attraction_params[:id]).soft_delete
      redirect_to attractions_path
    else
      render text: 'not ok'
    end
  end


  private

  def attraction_params
    params.require(:attraction).permit(:name, :longitude, :latitude, :address, :phone, :category_id)
  end

  def edit_attraction_params
    params.permit(:id)
  end

  def delete_attraction_params
    params.permit(:id)
  end
end
