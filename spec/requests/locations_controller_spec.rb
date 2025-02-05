require 'rails_helper'

RSpec.describe "Locations", type: :request do
  describe "POST /locations" do
    let(:api_key) { 'TEST_FAKE_KEY' }
    let(:valid_params) { { latitude: "40.7128", longitude: "-74.0060" } }
    let(:api_url) { "https://api.openweathermap.org/data/2.5/weather?lat=40.7128&lon=-74.0060&appid=#{api_key}" }

    before do
      allow(ENV).to receive(:fetch).with('OPEN_WEATHER_API_KEY').and_return(api_key)
    end

    context "with valid parameters" do
      let(:weather_data) do
        JSON.parse(File.read(Rails.root.join('spec', 'support', 'fixtures', 'open_weather_valid_response.json')))
      end

      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: weather_data.to_json)
      end

      it "redirects to new with temperature in flash" do
        post "/locations", params: valid_params
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:temperature]).to eq(284.2)
      end
    end

    context "with invalid parameters" do
      it "redirects with error for invalid latitude" do
        post "/locations", params: { latitude: "91", longitude: "-74.0060" }
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:alert]).to eq("Bad latitude or longitude.")
      end

      it "redirects with error for missing parameters" do
        post "/locations", params: { latitude: "40.7128" }
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:alert]).to eq("Bad latitude or longitude.")
      end
    end

    context "when OpenWeather API fails" do
      before do
        stub_request(:get, api_url)
          .to_return(status: 401, body: { message: "Invalid API key" }.to_json)
      end

      it "redirects with API error message" do
        post "/locations", params: valid_params
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:alert]).to eq("Invalid API key")
      end
    end
  end
end
