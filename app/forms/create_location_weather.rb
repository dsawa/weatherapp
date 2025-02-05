class CreateLocationWeather
  include ActiveModel::Model

  attr_reader :latitude, :longitude

  validates :latitude, :longitude, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end
end
