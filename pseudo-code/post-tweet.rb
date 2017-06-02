require 'twitter'

class PostTweet

   def initialize(config_file)
	  @config = getConfig(config_file)

	  @client = Twitter::REST::Client.new do |config|
		 config.consumer_key        = @config['consumer_key']
		 config.consumer_secret     = @config['consumer_secret']
		 config.access_token        = @config['access_token']
		 config.access_token_secret = @config['access_token_secret']
	  end

   end

   def post(message)
  
	  tweet = @client.update message

	  #Including 4 photos:
	  media_ids = %w(./images/nws_1.png ./images/nws_2.png ./images/nws_3.png ./images/nws_4.png).map do |filename|
	    client.upload File.new filename
	  end
	  
    message = "Tweeting with four photos."
	  tweet = client.update message, {media_ids: media_ids.join(',')}
   end
end


