class LocationsController < ApplicationController
  def index
    # get all locations in the table locations
    @locations = Location.all

    # to json format
    @locations_json = @locations.to_json
  end

  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end

  def snpi
    if location_near[:latitude]
      @location = Location.new({:latitude => location_near[:latitude], :longitude => location_near[:longitude], :name => '', :description => ''})
      @locations = Location.get_near_locations(@location,Location.all,location_near[:radius])

      # to json format
      @locations_json = @locations.to_json
    end
  end

  def convex
    @all_locations = Location.all
    @convex_hull_locations = Location.convex_hull(@all_locations)
    @perimeter = Location.perimeter(@convex_hull_locations)
    @farthest_distance_from_home = Location.get_farthest_distance(Location.find_by_name('Casa'), @all_locations)

    @params = {:convex_hull => @convex_hull_locations, :perimeter => @perimeter, :farthest_distance_from_home => @farthest_distance_from_home}
    # to json format
    @params_json = @params.to_json
  end

  def visited

    if location_route[:route]
      @locations = Location.get_visited_locations(location_route[:route].read, location_route[:radius])
      @locations_json = @locations.to_json
    end
  end

  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    @location = Location.new(location_params)

    # if the object saves correctly to the database
    if @location.save
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end
  end

  def edit
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])
  end

  def update
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # if the object saves correctly to the database
    if @location.update_attributes(location_params)
      # redirect the user to index
      redirect_to locations_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @location = Location.find(params[:id])

    # delete the location object and any child objects associated with it
    @location.destroy

    # redirect the user to index
    redirect_to locations_path, notice: 'Location was successfully deleted.'
  end

  def destroy_all
    # delete all location objects and any child objects associated with them
    Location.destroy_all

    # redirect the user to index
    redirect_to locations_path, notice: 'All locations were successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
  end

  private

  def location_params
    params.require(:location).permit(:latitude, :longitude, :description, :name)
  end

  def location_near
    params.permit(:latitude, :longitude, :radius)
  end

  def location_route
    params.permit(:route, :radius)
  end
end
