require 'twitter'
require 'optparse'
require 'yaml'

=begin
config = {
    consumer_key:    "",
    consumer_secret: "",
    access_token:    "",
    access_token_secret: ""
}
=end

class PostTweet

   attr_accessor :config,
				 :consumer_key, :consumer_secret, :access_token, :access_token_secret,
				 :client

   def initialize(config_file)
	  @config = getConfig(config_file)

	  @client = Twitter::REST::Client.new do |config|
		 config.consumer_key        = @config['consumer_key']
		 config.consumer_secret     = @config['consumer_secret']
		 config.access_token        = @config['access_token']
		 config.access_token_secret = @config['access_token_secret']
	  end

   end


   def getConfig(config_file)

	  config = YAML.load_file(config_file)

	  #Set account values.
	  @consumer_key = config['post_tweet']['consumer_key']
	  @consumer_secret = config['post_tweet']['consumer_secret']
	  @access_token = config['post_tweet']['access_token']
	  @access_token_secret = config['post_tweet']['access_token_secret']
	  
	  @config = {}
	  @config['consumer_key'] = @consumer_key
	  @config['consumer_secret'] = @consumer_secret
	  @config['access_token'] = @access_token
	  @config['access_token_secret'] = @access_token_secret 
	  
	  @config
	  
	  
   end

   def post(message)

	
	  tweet = @client.update message

	  #If you want to include 4 photos:
	  #media_ids = %w(./images/nws_1.png ./images/nws_2.png ./images/nws_3.png ./images/nws_4.png).map do |filename|
	  #  client.upload File.new filename
	  #end
	  #message = "Tweeting with four photos."
	  #tweet = client.update message, {media_ids: media_ids.join(',')}

	  puts "done."
	  
   end

end


#=======================================================================================================================
if __FILE__ == $0 #This script code is executed when running this file.

   OptionParser.new do |o|
	  o.on('-c CONFIG') { |config| $config = config }
	  o.on('-m MESSAGE') { |message| $message = message }
	  o.parse!
   end

   if $config.nil?
	  $config = './config.yaml' #Default
   end

   if $message.nil?
	  $message = "@snowman: OK, Pi Tweeting with Ruby and 'twitter' gem [default message]. Gearing up for round 2 of demo making..." #Default
   end
   
   message = $message

   poster = PostTweet.new($config)
   poster.post(message)

end

