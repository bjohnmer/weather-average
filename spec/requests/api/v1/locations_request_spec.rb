require 'rails_helper'

RSpec.describe 'Location', type: :request do
  before :each do
    location = Geocoder.search('New York City')
    lat = location.first.data['lat']
    lon = location.first.data['lon']
    @client = Client.create!({latitude: lat, longitude: lon})
    cookies[:weather_average] = @client.session_id
    @f_location = FactoryBot.create(:location, client: @client)
  end

  describe '#create' do
    let(:location_params) { FactoryBot.attributes_for(:location, city: 'Toronto') }

    it 'adds new city' do
      post api_v1_locations_path, params: { location: location_params }
      expect(response).to have_http_status 200
    end
  end

  describe '#update' do
    it 'returns new weather info' do
      put api_v1_location_path @f_location
      expect(response).to have_http_status 200
    end
  end

  describe '#destroy' do
    it 'remove some location' do
      delete api_v1_location_path @f_location
      expect(response).to have_http_status 200
    end
  end
end
