class OpenWeatherService
  OPEN_WEATHER_API_KEY = ENV.fetch("OPEN_WEATHER_API_KEY")
  Error = StandardError.new

  attr_reader :latitude, :longitude

  def initialize(locations_object)
    @latitude = locations_object.latitude
    @longitude = locations_object.longitude
  end

  def call
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{OPEN_WEATHER_API_KEY}")

    raise Error, "Bad Response" if response["status"] != 200


    response
  end
end
