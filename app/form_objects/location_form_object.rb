class LocationFormObject
  include ActiveModel::Model

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def valid?
    latitude.present? && longitude.present?
  end
end
