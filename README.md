# adventures in pi

A collection of notes about setting up a Raspberry Pi 3 for posting and collecting Twitter data. So far playing with Ruby, Python and Java. Node.js should be on this list too. 

Covers two-way communication, posting messages to the outside world, and listening for messages. 

One use-case that will drive this exploration is using Rapberry Pi 3s with early-warning systems, pondering remote sites that collect data. Although the power consumption may be an issue with remote, off-the-grid weather stations, in other fuller-power settings, the Pi 3 capabilites are exciting.

A first goal is to listen for the #iot_test hashtag with a HTTP Twitter stream, and immediately Tweet back to the sender. For this exercise I'll focus on consuming a Gnip PowerTrack stream on the Pi, and Tweet with the Public API (of course!).

## Posting Data

Posting data enables the Pi device to communicate to the outside world. Messages can be public via Tweets or private via Direct messages. An example use-case is having a weather station Tweet its readings. Another would be sending a private direct message to provide another device an 'event' to act on. 

Posting Tweets (and Direct Messages) is very straightforward on the Raspberry Pi. Languages such as Python, Ruby, and Java all have great resources for Tweeting. 

## Consuming data from Gnip

For these experiments, Gnip was the go-to source for data for a couple of reasons. First, many of the packages/gems used above to Tweet also support streaming data. So it is assumed that getting them to stream data should be straight-forward. Second, Gnip provides enterprise-grade data services that provide performance, data fidelity, and reliability demanded by early-warning systems.

Gnip focuses on the delivery of Twitter data and metadata, and provides a family of products that help users filter the realtime firehose or all-time archive for Tweets of interest. Gnip provides both RESTful APIs able to retrieve data on a near realtime basis and realtime streaming APIs that deliver data with minimum latency. 

[] add summary of streaming success


## Play notes ---------------------


## Posting Data 

### Python and Twitter API

Have Tweeted with these two packages. No issues with getting started.

+ sudo pip install twython
+ sudo pip install tweepy 
 
[Example Tweepy code](https://github.com/jimmoffitt/pi-adventures/blob/master/post_tweet.py)


### Ruby and Twitter API

Have Tweeted with the 'twitter' gem. Needed to install bundler and do a fresh ruby install. 

+ gem install bundle
+ sudo apt-get install ruby-install
+ gem install twitter 
 
 [Example code](https://github.com/jimmoffitt/pi-adventures/blob/master/post_tweet.rb) 
   + Note: failed to build native extensions before the previous ruby install.

### Java example

[] TODO


## Consuming data from Gnip

The use-case driving these experiments is enabling a device to listen for commands via Twitter. Data can be received by either making polls on some interval, or streaming in realtime.

+ Polling systems based on Gnip Search APIs (or Twitter public APIs) should be relatively easy to set-up.
+ Realtime streaming may be overkill but seems like an interesting POC, enabling realtime control with low latency.

## Restful Search APIs

[] TODO

## Realtime Streaming APIs

Gnip Streaming was a bit more challenging, but we got there.

### Python streaming

+ [gnippy](https://pypi.python.org/pypi/gnippy) more or less worked straight out of the box. [Example code](https://github.com/jimmoffitt/pi-adventures/blob/master/gnippy_stream.py).
    + Note: Using .gnippy configuration file had odd behavior, file not found on subsequent executions, so reverted to providing access tokens when creating client object.

### Ruby pt-stream-pi

+ Resurrected an early attempt at a Ruby multi-publisher stream consumer.
+ Refactoring it for both Pi and ptv2.
   + Removing mysql support. Will port to something much more light-weight.
   + Removing support for non-Twitter publishers. Removed code only supported annoying and simple differences in encoding metadata (like activity ids, geo details, even timestamps -- thanks StockTwits).
+ [Example code](https://github.com/jimmoffitt/pi-adventures/tree/master/pt-stream).

Deployed on Pi:
+ getting error about "Encryption not available on this event-machine"

```
pi@raspberrypi:~/play/pt-stream-pi $ ruby pt_stream_pi.rb
terminate called after throwing an instance of 'std::runtime_error'
  what():  Encryption not available on this event-machine
Aborted
```
   + A bit of searching revealed that the event-machine gem needed to be re-compiled *after* installing libssl-dev. Here are the steps I needed to take:
      + sudo apt-get install libssl-dev --> lots of complaints about not finding remote resources.
         + sudo apt-get update --> fixed those problems.
      + sudo gem uninstall eventmachine 
      + sudo gem install eventmachine
      + ruby pt_stream_pi.rb  --> boom!
  

When streaming an average of ~500 Tweets/minutes, the stream ran for over 24 hours before the stream volume was increased until the full-buffer disconnected at around 12K/minute with 28K Tweets in the buffer.

When streaming ~5K Tweets per minute it would run for ~10 minutes, then a client disconnection would be detected by server-side...
Streaming to standard out (terminal window) would continue for many minutes (twenty?).
At end of client-side stream were these messages:

```
76ea1000-76ea6000 rw-p 001ee000 b3:07 920280     /usr/lib/arm-linux-gnueabihf/libruby-2.1.so.2.1.0
76ebc000-76ebe000 r-xp 00000000 b3:07 919526     /usr/lib/arm-linux-gnueabihf/ruby/2.1.0/enc/encdb.so
76ecf000-76ed4000 r-xp 00000000 b3:07 919071     /usr/lib/arm-linux-gnueabihf/libarmmem.so
76ee4000-76f04000 r-xp 00000000 b3:07 1048717    /lib/arm-linux-gnueabihf/ld-2.19.so
7ea81000-7eaa2000 rwxp 00000000 00:00 0          [stack]
7ed76000-7ed77000 r-xp 00000000 00:00 0          [sigpage]
7ed77000-7ed78000 r--p 00000000 00:00 0          [vvar]
7ed78000-7ed79000 r-xp 00000000 00:00 0          [vdso]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]

[NOTE]
You may have encountered a bug in the Ruby interpreter or extension libraries.
Bug reports are welcome.
For details: http://www.ruby-lang.org/bugreport.html
```

### Java HBCpt2

Seems like pi in the sky at this point. Currently attempting to deploy by hand the [HBC udpated for ptv2](https://github.com/jimmoffitt/hbc).

+ Read up on installing a full horsepower IDE (IntelliJ specifically), but seems that would be overkill. 
+ Have deployed compiles classes on Pi, but external libraries are not found.
+ Playing around with $PATH, so far to no avail. 


### Notes

The general use-case to help provide data stories is based on both 

+ Integrating Twitter with early-warning systems.
+ Investigating the history of the use of Twitter during historic floods. 
 
Early-warning systems are based on meterological data collection and the public safety mission of providing alarms and notifications. 

These systems can readily add Twitter as a broadcast channel, and have the potential to listen for Tweets of interest. 

## Challenges of low-volume streams

When considering challenges related to streaming Twitter data, managing high data volumes is the one that first comes to mind. When Gnip customers have issues with maintaining a stream connection, it usually is due to not keeping up and experiencing a forced disconnect after the server-side buffer fills up. When forced disconnects are happening, the go-to advice is to focus on the stream consumer object and make sure it is not doing a lot of 'heavy-lifting', not parsing JSON, not applying any logic, but instead is just writing received data to a queue... 

With the type of use-case I had in mind for the raspberry pi, I experienced a challenge due to the opposite scenario: very low volume streams. I needed to build a stream consumer that could receive very low amounts of data, such as one Tweet every hour or so. When I first tested with such a low-volume stream, I used the EventMachine-based Ruby consumer mentioned above. I started the stream consumer, and Tweeted the \#iot_test hashtag and waited... and waited... and waited. Nothing happened. I was expecting the normal second or so latency between posting the Tweet and see it arrive in my app. After about five minutes, I added a high-volume filter to my PowerTrack stream and immediately after saw the \#iot_test Tweet arrive. Turns out it was hanging out in a client-side streaming buffer until enough subsequent Tweets arrived and pushed it out of that buffer... 

One solution here is to dig into the EventMachine code and tinkering with its internal buffers. Before doing that, I decided to experiment with a cURL-based Ruby stream consumer (used the curb gem) under the assumption that since it was based on cURL that there may not be any buffering issue. This potentially naive assumption was based on my experience with cURL and always seeing low latency with low-volume streams. 

So I took the Gnip simplistic curb-based Ruby code snippet, and sure enough, it handled the low-volume stream perfectly, 'surfacing' a single Tweet as fast as pure cURL. The downside of that code-based is its simplicity, with no logging, no configuration management, and no delivery of whole-Tweet, but rather generating data with Tweets sometimes split between data chunks. However, I hit a roadblock when attempting to deploy the curb-based app on the Raspberry Pi. I was unable to get the curb gem installed on the Raspbery Pi 3... 

After following a few 'install curb' recipes with no success, the next step was testing other stream consumers. I spun up a Python gnippy-based stream, and got the low-volume handling I was looking for. My single Tweet showed up in about a second. 


## Building a simple Twitter bot

So, I finally had both a low-volume-ready listening app and a Tweeting app deployed and running on the Pi. Even though this was a Python-based consumer and a Ruby-based Tweeter, it seemed like a fun idea to make these pieces work together. The consumer and Tweeting apps are being deployed as separate processes, so the underlying language shouldn't matter. For the first, all-Ruby curb-based attempt, the Ruby ``` `#{command}` ``` mechanism seemed to do the job. For the Python-calling-Ruby process, I went with the Python ```subprocess.check_output()``` method. 

This plumbing worked out of the (pi) box. I had a simple Twitter Bot runnning on a Raspbery Pi 3.

So a Tweet like this with a 'trigger' hashtag:
 ![](https://github.com/jimmoffitt/pi-adventures/blob/master/images/triggerTweet.jpg)
 
 Results in this Tweet:
  ![](https://github.com/jimmoffitt/pi-adventures/blob/master/images/responseTweet.jpg)
 


## Random notes:

First attempt to construct complete, independent Tweets when streaming with Ruby curb:

```ruby

Curl::Easy.http_get url do |c|
   c.http_auth_types = :basic
   c.username = user
   c.password = pass

   c.encoding = "gzip"
   c.verbose = true

   tweet = ''
   c.on_body do |line|

	  tweetHandler.show line

	  if line.strip == ''
		 puts "Heartbeat from server"
	  else
		 complete = false
		 if line.start_with? '{"created_at"' and line.strip.end_with? '}'
			tweet = line.strip
			complete = true
		 elsif line.start_with? '{"created_at"'
			tweet = line.strip
			complete = false
		 elsif line.end_with? '}'
			tweet = tweet + line.strip
			complete = true
		 elsif line.include? '}{'
			puts "need to handle '}{' pattern."
		 end

		 tweetHandler.check tweet if complete and tweet != ''
		 tweet = ''

	  end

	  line.size # required by curl's api.
   end

end

```

