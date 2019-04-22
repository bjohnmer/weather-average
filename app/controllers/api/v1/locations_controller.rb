module Api::V1
  class LocationsController < ApplicationController
    before_action :set_client
    before_action :set_location, only: [:update, :destroy]

    def create
      service = ApixuService.new(location_params[:city])
      loc = service.get_location
      message = 'Location not found!' if !loc
      location = @client.locations.create_with(loc).find_or_create_by(city: loc[:city]) unless !loc
      unless location.nil?
        message = "Error storing: #{location.errors.full_messages.to_sentence}" if location.errors.messages.any?
      end
      render status: 401, json: {
        message: message || ''
      } and return unless location
      html_content = html_render('locations/locations', nil, @client.locations)
      response = service.forecast
      response_data = html_render('home/response', response)
      render status: 200, json: { html_content: html_content, response_data: response_data  }
    end

    def update
      service = ApixuService.new(@location.city)
      loc = service.get_location
      render status: 401, json: {
        message: "Error updating: #{@location.errors.full_messages.to_sentence}"
      } and return unless @location.update(loc)
      html_content = html_render('locations/locations', nil, @client.locations)
      response = service.forecast
      response_data = html_render('home/response', response)
      render status: 200, json: { html_content: html_content, response_data: response_data  }
    end

    def destroy
      render status: 401, json: {
        message: "Error deleting: #{@location.errors.full_messages.to_sentence}"
      } and return unless @location.destroy
      html_content = html_render('locations/locations', nil, @client.locations)
      render status: 200, json: { html_content: html_content }
    end

    private
      def location_params
        params.require(:location).permit(:city)
      end

      def set_client
        session_id = cookies[:weather_average]
        @client = Client.find_by_session_id(session_id)
        render status: 404, json: {
          message: 'Client not found'
        } and return unless @client
      end

      def set_location
        @location = @client.locations.find(params[:id])
        render status: 404, json: {
          message: 'Location not found'
        } and return unless @location
      end

      def html_render(partial_name, response_data, locations = nil)
        render_to_string partial: partial_name,
          formats: :html,
          layout: false,
          locals: { response_data: response_data, locations: locations }
      end
  end
end
