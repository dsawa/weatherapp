require 'rails_helper'

RSpec.describe LocationWeather do
  let(:temperature) { 23.5 }
  subject(:location_weather) { described_class.new(temperature) }

  describe "#valid?" do
    context 'when valid temperature' do
      it "is valid with a numerical temperature" do
        expect(location_weather).to be_valid
      end
    end

    context 'when invalid temperature' do
      context 'when temperature is string' do
        let(:temperature) { "hot" }

        it "is invalid with non-numerical temperature" do
          expect(location_weather).not_to be_valid
          expect(location_weather.errors[:temp]).to include("is not a number")
        end
      end

      context 'when temperature is nil' do
        let(:temperature) { nil }

        it "is invalid without temperature" do
          expect(location_weather).not_to be_valid
          expect(location_weather.errors[:temp]).to include("can't be blank")
        end
      end
    end
  end

  describe "#temp" do
    it "returns the temperature value" do
      expect(location_weather.temp).to eq(temperature)
    end
  end
end
