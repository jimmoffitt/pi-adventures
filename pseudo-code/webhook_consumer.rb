require 'sinatra'
require_relative "../../app/helpers/event_manager"

class EnrollerApp < Sinatra::Base

	def generate_crc_response(consumer_secret, crc_token)
		hash = OpenSSL::HMAC.digest('sha256', consumer_secret, crc_token)
		return Base64.encode64(hash).strip!
	end

	get '/' do
		"Welcome to the @FloodSocial notification system! <br>
          This websocket component is used for enrolling subscribers into a geo-aware, Twitter-based notification system. <br>
          This component is a consumer of Account Activity API events, and uses Direct Message API to communicate to recipient account.
     "
	end

	# Receives challenge response check (CRC).
	get '/webhooks/twitter' do
		crc_token = params['crc_token']
		response['response_token'] = "sha256=#{generate_crc_response(settings.dm_api_consumer_secret, crc_token)}"
    body response.to_json
    status 200
	end

	# Receives DM events.
	post '/webhooks/twitter' do
		event = request.body.read
		manager.handle_event(event)
  end
end
