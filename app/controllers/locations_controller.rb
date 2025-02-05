class LocationsController < ApplicationController
  def show
  end

  def new
  end

  def create
    form_object = LocationFormObject.new(location_params[:latitude], location_params[:longitude])

    if form_object.valid?
      response = OpenWeatherService.new(form_object).call
      @weather = LocationWeather.new(response["main"]["temp"])
      render :new, notice: "Success"
    else
      flash[:alert] = "Bad latitude or longitude."
      render :new
    end
  end

  private

  def location_params
    params.permit(:latitude, :longitude)
  end
end
