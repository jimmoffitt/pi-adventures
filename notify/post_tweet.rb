
require 'twitter'

config = {
    consumer_key:    "",
    consumer_secret: "",
    access_token:    "",
    access_token_secret: ""
}

client = Twitter::REST::Client.new(config)

#If you want to include 4 photos:
#media_ids = %w(./images/nws_1.png ./images/nws_2.png ./images/nws_3.png ./images/nws_4.png).map do |filename|
#  client.upload File.new filename
#end
#tweet = client.update "Tweeting with four photos.", {media_ids: media_ids.join(',')}

tweet = client.update "OK, Pi Tweeting with Ruby and 'twitter' gem."

puts "done."
