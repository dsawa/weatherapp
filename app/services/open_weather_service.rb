class OpenWeatherService
  OPEN_WEATHER_API_KEY = ENV.fetch("OPEN_WEATHER_API_KEY")
  Error = Class.new(StandardError)

  attr_reader :latitude, :longitude

  def initialize(locations_object)
    @latitude = locations_object.latitude
    @longitude = locations_object.longitude
  end

  def call
    open_weather_response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{OPEN_WEATHER_API_KEY}")

    json_response = JSON.parse(open_weather_response.body)

    raise Error, json_response["message"] if open_weather_response.code != 200

    json_response.with_indifferent_access
  end
end
