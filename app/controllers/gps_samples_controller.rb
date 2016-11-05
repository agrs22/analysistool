class GpsSamplesController < ApplicationController
  def index
    # get all locations in the table locations
    @gps = Gps_sample.all
    # to json format
    @gps_json = @gps.to_json
  end


  def new
    # default: render ’new’ template (\app\views\locations\new.html.haml)
  end
  def locbyuser
    # default: render ’new’ template (\app\views\locations\new.html.haml)
    @gps = Gps_sample.where(user: user_n[:who])
    @gps_json = @gps.to_json
  end
  def create
    # create a new instance variable called @location that holds a Location object built from the data the user submitted
    if location_route[:route]
      @finished = Gps_sample.save_gps_sample(location_route[:route].read, location_route[:who])
    end
    if @finished
      # redirect the user to index
      redirect_to gps_samples_path, notice: 'Location was successfully created.'
    else
      # redirect the user to the new method
      render action: 'new'
    end

  end


  def edit
    # find only the location that has the id defined in params[:id]
    @gps = Gps_sample.find(params[:id])
  end

  def update
    # find only the location that has the id defined in params[:id]
    @gps = Gps_sample.find(params[:id])

    # if the object saves correctly to the database
    if @gps.update_attributes(location_params)
      # redirect the user to index
      redirect_to gps_samples_path, notice: 'Location was successfully updated.'
    else
      # redirect the user to the edit method
      render action: 'edit'
    end
  end

  def destroy
    # find only the location that has the id defined in params[:id]
    @gps = Gps_sample.find(params[:id])

    # delete the location object and any child objects associated with it
    @gps.destroy

    # redirect the user to index
    redirect_to gps_samples_path, notice: 'Location was successfully deleted.'
  end

  def destroy_all
    # delete all location objects and any child objects associated with them
    Gps_sample.destroy_all

    # redirect the user to index
    redirect_to gps_samples_path, notice: 'All locations were successfully deleted.'
  end

  def show
    # default: render ’show’ template (\app\views\locations\show.html.haml)
  end

  private



  def latlonra
    params.permit(:latitude, :longitude, :radius)
  end

  def location_route
    params.permit(:route, :who)
  end
  def user_n
    params.permit(:who)
  end
end
