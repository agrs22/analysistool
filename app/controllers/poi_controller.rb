class PoiController < ApplicationController
  def index
    # get all locations in the table locations
    @locations = Location.all

    # to json format
    @locations_json = @locations.to_json
  end

  private

  def location_params
    params.require(:location).permit(:latitude, :longitude, :description, :name)
  end
end
