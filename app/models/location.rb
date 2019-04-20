class Location < ApplicationRecord
  belongs_to :client
  validates :city, presence: true
end
