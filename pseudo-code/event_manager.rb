#POST requests to /webhooks/twitter arrive here.
#Twitter Account Activity API send events as POST requests with DM JSON payloads.

class EventManager

def handle_event(events)
    events = JSON.parse(events) 
    
    #DMs are first events to be delivered via Account Activity API.
    if events.key? ('direct_message_events') 
        dm_events = events['direct_message_events']
        dm_events.each do |dm_event|  
	    #Process Direct Message and generate response.
		
        end
    end
end

	  
	  
	  
	  
	  
	  
	  
	  
				if dm_event['type'] == 'message_create'

					#Is this a response? Test for the 'quick_reply_response' key.
					is_response = dm_event['message_create'] && dm_event['message_create']['message_data'] && dm_event['message_create']['message_data']['quick_reply_response']

					if is_response
						response = dm_event['message_create']['message_data']['quick_reply_response']['metadata']
						user_id = dm_event['message_create']['sender_id']

						if response == 'add_area'
							@DMSender.send_area_method(user_id)
							#And many other response 'types'
						end
					else
						#Since this DM is not a response to a QR, let's check for other 'action' commands
						#puts 'Received a command/question DM? Need to track conversation stage?'

						request = dm_event['message_create']['message_data']['text']
						user_id = dm_event['message_create']['sender_id']

						if request.length < COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'home' or request.downcase.include? 'add' or request.downcase.include? 'main' or request.downcase.include? 'hello')
							puts 'Send QR to add an area'
							#Send QR for which 'select area' method
							@DMSender.send_welcome_message(user_id)
						
						end
					end
				end
			end
		end
	end
end
