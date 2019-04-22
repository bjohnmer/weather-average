require 'rails_helper'

RSpec.describe ApixuService do
  let(:city) { 'Los Angeles' }
  subject(:location) { ApixuService.new(city) }

  describe '#forecast' do
    context 'when city\'s name is ok' do
      it 'returns a hash with all city info' do
        params = "key=#{ENV['APIXU_KEY']}&q=#{city}&days=7"
        success_hash = location.send(:call, ApixuService::APIXU_BASEURL + params)
        expect(location.forecast).to eq success_hash
      end
    end

    context 'when city name is wrong' do
      let(:city) { 'MySuperCityWrongName' }

      it 'returns a hash with not found message' do
        error_hash = {"error"=>{"code"=>1006, "message"=>"No matching location found."}}
        expect(location.forecast).to eq error_hash
      end
    end
  end

  describe '#get_location' do
    context 'when location is ok' do
      it 'returns weather info for some city' do
        location.forecast
        temps_c = location.location['forecast']['forecastday'].map { |fd| fd['day'] }.pluck('avgtemp_c')
        temps_f = location.location['forecast']['forecastday'].map { |fd| fd['day'] }.pluck('avgtemp_f')
        atemp_c = temps_c.sum / temps_c.count
        atemp_f = temps_f.sum / temps_f.count
        success_hash = {
          last_tavg: "#{atemp_c.round(1)}ºC/#{atemp_f.round(1)}ºF",
          city: location.location['location']['name']
        }
        expect(location.get_location).to eq success_hash
      end
    end

    context 'when location not found' do
      let(:city) { 'MySuperCityWrongName' }

      it 'returns false' do
        expect(location.get_location).to eq false
      end
    end
  end
end
