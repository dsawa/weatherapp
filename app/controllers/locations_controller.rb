class LocationsController < ApplicationController
  def new
    @weather = LocationWeather.new(flash[:temperature]) if flash[:temperature]
  end

  def create
    form_object = CreateLocationWeather.new(location_params[:latitude], location_params[:longitude])

    if form_object.valid?
      response = OpenWeatherService.new(form_object).call
      flash[:temperature] = response.dig(:main, :temp)
      redirect_to new_locations_path
    else
      flash[:alert] = "Bad latitude or longitude."
      redirect_to new_locations_path
    end

  rescue OpenWeatherService::Error => e
    flash[:alert] = e.message
    redirect_to new_locations_path
  end

  private

  def location_params
    params.permit(:latitude, :longitude)
  end
end
