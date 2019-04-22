class ApixuService
  APIXU_BASEURL = 'http://api.apixu.com/v1/forecast.json?'

  attr_reader :city, :location

  def initialize(city)
    @city = city
    @location = []
  end

  def forecast
    params = "key=#{ENV['APIXU_KEY']}&q=#{city}&days=7"
    call(APIXU_BASEURL + params)
  end

  def get_location
    forecast
    unless (@location.key?('error'))
      temps_c = @location['forecast']['forecastday'].map { |fd| fd['day'] }.pluck('avgtemp_c')
      temps_f = @location['forecast']['forecastday'].map { |fd| fd['day'] }.pluck('avgtemp_f')
      atemp_c = temps_c.sum / temps_c.count
      atemp_f = temps_f.sum / temps_f.count
      {
        last_tavg: "#{atemp_c.round(1)}ºC/#{atemp_f.round(1)}ºF",
        city: @location['location']['name']
      }
    else
      false
    end
  end

  private

    def call(url)
      conn = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
      response = conn.get
      @location = JSON.parse(response.body)
    end
end

