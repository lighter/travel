class HomePageController < ApplicationController
  def index
  end

  def ajaxGetAttractions
    @attractions = Attraction.paginate(page: params[:page], per_page: 5)

    # render_to_string 'template/_attraction_view', layout: false

    render json: {
        data:     render_to_string('template/_attraction_view', layout: false),
        pageInfo: {
            current_page: @attractions.current_page,
            total_page:   @attractions.total_pages,
            per_page:     @attractions.per_page,
            total_count:  @attractions.total_entries,
            next_page:    @attractions.next_page,
        }
    }
  end
end
