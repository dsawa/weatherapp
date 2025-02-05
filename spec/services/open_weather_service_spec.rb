require 'rails_helper'

RSpec.describe OpenWeatherService do
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:api_key) { 'TEST_FAKE_KEY' }
  let(:location) { double(latitude: latitude, longitude: longitude) }

  subject(:service) { described_class.new(location) }

  before do
    allow(ENV).to receive(:fetch).with('OPEN_WEATHER_API_KEY').and_return(api_key)
  end

  describe '#initialize' do
    it 'sets latitude and longitude from location object' do
      expect(service.latitude).to eq(latitude)
      expect(service.longitude).to eq(longitude)
    end
  end

  describe '#call' do
    let(:api_url) { "https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{api_key}" }

    context 'when the API call is successful' do
      let(:weather_data) do
        JSON.parse(File.read(Rails.root.join('spec', 'support', 'fixtures', 'open_weather_valid_response.json')))
      end

      before do
        stub_request(:get, api_url).
        with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).to_return(status: 200, body: weather_data.to_json)
      end

      it 'returns parsed weather data' do
        response = service.call
        expect(response[:main][:temp]).to eq(284.2)
        expect(response[:main][:feels_like]).to eq(282.93)
        expect(response[:main][:temp_min]).to eq(283.06)
        expect(response[:main][:temp_max]).to eq(286.82)
        expect(response[:main][:pressure]).to eq(1021)
        expect(response[:main][:humidity]).to eq(60)
        expect(response[:main][:sea_level]).to eq(1021)
        expect(response[:main][:grnd_level]).to eq(910)
      end
    end

    context 'when the API call fails with 400' do
      before do
        stub_request(:get, api_url)
          .to_return(status: 400, body: { message: 'Invalid coordinates' }.to_json)
      end

      it 'raises an error with the error message' do
        expect { service.call }.to raise_error(OpenWeatherService::Error, 'Invalid coordinates')
      end
    end

    context 'when the API call fails' do
      before do
        stub_request(:get, api_url)
          .to_return(status: 401, body: { message: 'Invalid API key' }.to_json)
      end

      it 'raises an error with the error message' do
        expect { service.call }.to raise_error(OpenWeatherService::Error, 'Invalid API key')
      end
    end
  end
end
