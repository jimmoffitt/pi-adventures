=begin

PtStream - PowerTrack streaming class.

Written to manage the streaming of a single PowerTrack connection. If more than one stream is needed, multiple instances
of this class can be spun up.

This is being written with an eye on using it as a Rails background process, streaming activities and writing them to a
local database.  The Rails application will ride on top of this database.

=end

require_relative "./http_stream" #based on gnip-stream project at (https://github.com/rweald/gnip-stream).
require 'base64'
require 'time'
require 'optparse'
require 'logger'
require 'yaml'


class PtStream

   attr_accessor :stream, :account_name, :user_name, :password_encoded,
				 :stream_label,
				 :url,
				 :activities,
				 :output,
				 :log, :log_level, :log_file


   def initialize(config)

	  @activities = Array.new #TODO: may want to use Queue class instead (thread safe).

	  if not config.nil? then
		 getConfig(config)
	  end

	  #Set up logger.
	  @log = Logger.new(@log_file, 10, 10240000) #Roll log file at 10 MB, save ten. (@ debug fills up fast)
	  if @log_level == 'debug' then
		 Logger::DEBUG
	  elsif @log_level == 'info'
		 Logger::INFO
	  elsif @log_level == 'warn'
		 Logger::WARN
	  elsif @log_level == 'error'
		 Logger::ERROR
	  elsif @log_level == 'fatal'
		 Logger::FATAL
	  end

	  @log.info { "Creating Streaming Client object with config file: " + config }
   end

   def getPassword
	  #You may want to implement a more secure password handler.  Or not.
	  @password = Base64.decode64(@password_encoded) #Decrypt password.
   end

   def getConfig(config_file)

	  config = YAML.load_file(config_file)

	  #Set account values.
	  @account_name = config['account']['name']
	  @user_name = config['account']['user_name']
	  @password_encoded = config['account']['password_encoded']
	  @password = getPassword

	  #Set stream details.
	  @stream_label = config['stream']['label']
	  @output = config['stream']['output']

	  @url = setURL

	  #Set logging details.
	  @log_level = config['logging']['log_level']
	  @log_file = config['logging']['log_file']

   end

   def setURL
	  "https://stream.gnip.com:443/accounts/#{@account_name}/publishers/twitter/streams/track/#{@stream_label}.json"
   end

   #NativeID is defined as a string.  This works for Twitter, but not for other publishers who use alphanumerics.
   #Tweet "id" field has this form: "tag:search.twitter.com,2005:198308769506136064"
   #This function parses out the numeric ID at end.
   def getNativeID(data)

	  id= data["id"]

	  native_id = id.split(":")[-1]

	  return native_id
   end

   #Twitter uses UTC.
   def getPostedTime(data)


	  time_stamp = data["postedTime"]

	  if not time_stamp.nil? then
		 time_stamp = Time.parse(time_stamp).strftime("%Y-%m-%d %H:%M:%S")
	  else #This an activity without a PostedTime, such as a Tumblr post delete...
		 p "Using Now for timestamp..."
		 time_stamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
	  end

	  time_stamp
   end

   def getGeoCoordinates(activity)

	  #safe defaults... well, sort of...  defaulting to off the west coast of Africa...
	  latitude = 0
	  longitude = 0


	  geo = activity["geo"]

	  if not geo.nil? then #We have a "root" geo entry, so go there to get Point location.
		 if geo["type"] == "Point" then
			latitude = geo["coordinates"][0]
			longitude = geo["coordinates"][1]

			#We are done here, so return
			return latitude, longitude
		 end
	  end


	  return latitude, longitude
   end


   #Returns a comma-delimited list of rule values and tags.
   #values, tags
   def getMatchingRules(matching_rules)
	  values = ""
	  tags = ""
	  matching_rules.each do |rule|
		 values = values + rule["value"] + ","
		 if not rule["tag"].nil?
			tags = tags + rule["tag"] + ","
		 else
			tags = ""
		 end
	  end

	  return values.chomp(","), tags.chomp(",")
   end


   def getPlace(data)

	  place = data["location"]

	  if not place.nil? then
		 place = data["location"]["displayName"]
	  end

	  place

   end

   #Parse the body/message/post of the activity.
   def getBody(data)

	  body = data["body"]

	  body
   end

   '' '
    Parses normalized PtActivity Stream JSON.
    Parsing details here are driven by the current database schema used to store activities.
    If writing files, then just write out the entire activity payload to the file.
    ' ''

   def processResponseJSON(activity)

	  log.debug 'Entering processResponseJSON'

	  if @output == 'stdout' then
		 puts activity
		 return #all done here, not writing to db.
	  end

   end

   #There is one thread for streaming/consuming data, and it calls this.
   def consumeStream(stream)
	  begin
		 stream.consume do |message|

			#message.force_encoding("UTF-8")

			@activities << message #Add to end of array.

			if message.scan(/"gnip":/).count > 1 then
			   @log.warn { "Received corrupt JSON? --> #{message}" }
			end

			if @activities.length > 1000 then
			   @log.debug "Queueing #{@activities.length} activities..."
			end

		 end
	  rescue => e
		 @log.error { "Error occurred in consumeStream: #{e.message}" }
		 consumeStream(@stream)
	  end
   end

   #There is one thread for storing @activities, and it is calls this.
   def storeActivities
	  while true
		 while @activities.length > 0
			activity = @activities.shift #FIFO, popping from start of array.

			if activity.scan(/"gnip":/).count > 1 then
			   @log.warn { "Received corrupt JSON? --> #{activity}" }
			end

			processResponseJSON(activity)
		 end
		 sleep (0.5)
	  end
   end


   #Single thread for streaming, and another for handling received data.
   def streamData

	  threads = [] #Thread pool.

	  @stream = PowertrackStream.new(@url, @user_name, @password)

	  #t = Thread.new {Thread.pass; consumeStream(stream)}
	  t = Thread.new { consumeStream(stream) }

	  begin
		 t.run
	  rescue ThreadError => e
		 @log.error { "Error starting consumer thread: #{e.message}" }
	  rescue => e
		 @log.error { "Error starting consumer thread: #{e.message}" }
	  end

	  threads << t #Add it to our pool (array) of threads.

	  #OK, add a thread for consuming from @activities.
	  #This thread sends activities to the database.
	  t = Thread.new { storeActivities }

	  begin
		 t.run
	  rescue ThreadError => e
		 @log.error { "Error starting storeActivity thread: #{e.message}" }
	  end

	  threads << t #Add it to our pool (array) of threads.

	  threads.each do |t|
		 begin
			@log.debug('here')
			t.join
		 rescue ThreadError => e
			@log.error { "Error with thread join: #{e.message}" }
		 rescue => e
			@log.error { "Error with thread join: #{e.message}" }
		 end
	  end

   end

end


#=======================================================================================================================
if __FILE__ == $0 #This script code is executed when running this file.

   OptionParser.new do |o|
	  o.on('-c CONFIG') { |config| $config = config }
	  o.parse!
   end

   if $config.nil?
	  $config = "./config_private.yaml" #Default
   end

   pt = PtStream.new($config)
   pt.streamData

end
