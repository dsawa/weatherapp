require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to be_successful
    end

    context 'when temperature is in flash' do
      it 'assigns @weather' do
        allow_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:[]).with(:temperature).and_return(294.15)
        get :new
        expect(assigns(:weather)).to be_a(LocationWeather)
        expect(assigns(:weather).temp).to eq(294.15)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { latitude: 51.5074, longitude: -0.1278 } }
    let(:invalid_params) { { latitude: 91, longitude: -0.1278 } }
    let(:weather_service) { instance_double(OpenWeatherService) }
    let(:weather_response) { { "main" => { "temp" => 294.15 } }.with_indifferent_access }

    context 'with valid parameters' do
      before do
        allow(OpenWeatherService).to receive(:new).and_return(weather_service)
        allow(weather_service).to receive(:call).and_return(weather_response)
      end

      it 'redirects to new_locations_path with temperature in flash' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:temperature]).to eq(294.15)
      end
    end

    context 'with invalid parameters' do
      it 'redirects with error message' do
        post :create, params: invalid_params
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:alert]).to eq('Bad latitude or longitude.')
      end
    end

    context 'when OpenWeatherService raises an error' do
      before do
        allow(OpenWeatherService).to receive(:new).and_return(weather_service)
        allow(weather_service).to receive(:call).and_raise(OpenWeatherService::Error, 'API Error')
      end

      it 'redirects with error message' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_locations_path)
        expect(flash[:alert]).to eq('API Error')
      end
    end
  end
end
