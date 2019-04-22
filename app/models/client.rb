class Client < ApplicationRecord
  has_many :locations

  before_create :generate_session_id

  private

    def generate_session_id
      self.session_id = SecureRandom.base64
    end
end
