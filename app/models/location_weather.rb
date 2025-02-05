class LocationWeather
  include ActiveModel::Model

  attr_reader :temp

  validates :temp, numericality: true, presence: true

  def initialize(temp)
    @temp = temp
  end
end
