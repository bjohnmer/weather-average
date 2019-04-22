FactoryBot.define do
  location = Geocoder.search('New York City')
  factory :client do
    latitude { location.first.data['lat'] }
    longitude { location.first.data['lon'] }
  end
end
