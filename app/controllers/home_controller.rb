class HomeController < ApplicationController
  before_action :set_location
  before_action :set_session

  def welcome
    @response = []
    if @location.any?
      @response = ApixuService.new(@location_city).forecast
    end
  end

  private
    def set_location
      @location_city = (request.remote_ip == '::1' || request.remote_ip == '127.0.0.1') ? 'New York City' : request.remote_ip
      @location = Geocoder.search(@location_city)
      if @location.any?
        if @location.first
          @location_city = @location_city == 'New York City' ?
            @location.first.display_name.split(',').first :
            ( @location.as_json.first ?
              ( @location.first.as_json.key?('data') ?
                @location.first.city :
                'New York') :
            'New York')
        end
      end
    end

    def set_session
      lat, lon = '',''
      if @location.first.data.key?('loc')
        lat, lon = @location.first.data['loc'].split(',')
      else
        lat, lon = @location.first.data['lat'], @location.first.data['lon']
      end
      if cookies[:weather_average]
        @client = Client.find_by_session_id(cookies[:weather_average])
        @client = Client.create!({latitude: lat, longitude: lon}) unless @client
      else
        @client = Client.create!({latitude: lat, longitude: lon})
        cookies.permanent[:weather_average] = @client.session_id
      end
    end
end
