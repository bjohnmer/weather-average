require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should belong_to(:client) }
  it { should validate_presence_of(:city) }
end
