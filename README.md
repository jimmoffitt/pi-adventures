# adventures in pi

+ [Introduction](#intro)
+ [Design goals](#design-goals)

+ [Core Functionality](#core-functionality)
+ [Listening](#listen)
+ [Notifying](#notify)

+ [Article-like pieces](#articles)
+[Challenges of low-volume streams](#low-volume-streams)
+[Building a simple Twitter Responder](#twitter-responder)
+[Conferences Demos, mixed blessings]#conference-demos)


+ [Code notes and examples](#code-notes)

## Introduction <a id="intro" class="tall">&nbsp;</a>

A collection of notes about setting up a Raspberry Pi 3 for posting and collecting Twitter data. So far playing with Ruby, Python and Java. Node.js should be on this list too. 

Covers two-way communication, both sending notifications (to the outside world), and listening for messages (from the Twitter Platform). Possible notifications include posting Tweets, sending private Direct Messages, and sending emails. 

This functionality, and the example code that goes with it, is the primary goal. Deploying this on a Raspberry Pi is just part of the adventure. Beyond seeming like a fun exercise, doing that will help demonstrate that the underlying use of the Twitter APIs can be done in a very *light-weight* fashion. That it is very possible to combine Raspberry Pis, Twitter APIs, and a software language of your choice and stand up a remote, real-time notification system.

One use-case that will drive this exploration is *early-warning systems*, systems that *listen* for triggers and *notify* *subsribers* when a *threshold* of concern is met. Early-warning systems have many applications, but here we are going to be focused on *flood* warning systems. These systems collect a variety of real-time *weather* data, test incoming data against a set of *alarm thresholds*, and then *notify* subscribers. Flood early-warning systems are based on a set of remote, distributed *components*. These include a network of data collection sites and a *base station* that compiles and shares incoming data, as well as managing alarm definitions and notifications. There are a variety of communication protcols used to exchange data between these components, including line-of-sight radio, satellite, and HTTP over LAN, celluar, and wireless internet.

Building early-warning system components on a "micro" computer is very compelling. The device used here is a [Raspberry Pi 3, Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/). The Pi 3 runs many flavors of Linux and has a 1.2GHz quad-core, 1 GB RAM, micro-SD card slot, Bluetooth, 802.11n Wireless LAN, full HMDI, and 4 USB ports. On top of those computing skills, it costs around US$ 35, and is the size of a bar of soap. Wow. 

With these devices it is easy to envision remote devices that collect weather data and forward them to base stations. It is also easy to imagine a remote device not only listens for triggers, but also natively sends notifications via networks such as Twitter. Although power consumption may be an issue with remote, off-the-grid weather stations, in other fuller-power settings, the Pi 3 capabilites are exciting. (if the Pi 3's power consumption is a blocker, there are other lower power options like the [Pi Zero](https://www.raspberrypi.org/products/pi-zero/) and [Pi 1 Model A+](https://www.raspberrypi.org/products/model-a-plus/). More power consumption information [HERE](https://www.raspberrypi.org/help/faqs/)).


## Design Goals <a id="design-goals" class="tall">&nbsp;</a>

Demo goals really...

A first goal is to listen for the #iot_test hashtag with a HTTP Twitter stream, and immediately Tweet back to the sender. For this exercise I'll focus on consuming a Gnip PowerTrack stream on the Pi, and Tweet with the Public API (of course!).

Next steps would be:
+ Running *listener* that triggers on Tweets coming from an *area of interest*, a select 25mix25mi bounding-box.
	+ When a trigger Tweet is received, a *Notify* app notifies a list of subscribers to that area of interest.
    
+ With Twitter DM API, enroll subscribers and have them share their *area of interest*.

## Core functionality/components <a id="core-functionality" class="tall">&nbsp;</a>

### Listening --> /listen <a id="listen" class="tall">&nbsp;</a>

#### Streaming real-time Tweets

For these experiments, Gnip was the go-to source for data for a couple of reasons. First, many of the packages/gems used above to Tweet also support streaming data. So it is assumed that getting them to stream data should be straight-forward. Second, Gnip provides enterprise-grade data services that provide performance, data fidelity, and reliability demanded by early-warning systems.

Gnip focuses on the delivery of Twitter data and metadata, and provides a family of products that help users filter the realtime firehose or all-time archive for Tweets of interest. Gnip provides both RESTful APIs able to retrieve data on a near realtime basis and realtime streaming APIs that deliver data with minimum latency. 

[] add summary of streaming success




### Notifications --> /notify<a id="notify" class="tall">&nbsp;</a>


The Notification manager is a set of apps that know how send notifications to remote places. These notifications can arrive by Tweet, Direct Message, SMS, and email. The focus of this initial experiment will be on using the Twitter platform for managing notifications. So, we'll start with sending Tweets and Direct Messages.

Posting data enables the Pi device to communicate to the outside world.  Alarms and alerts are not that useful it their notification does not get through to the intended audience. Notifications are the last and most important interface with the public and partners. 

The focus here will be building Tweets, Direct Messages, and email notifications into the Pi 3 example.

The first POC here is building a client app that Tweets to a specified account when a followed account Tweets from a client-selected area.

Client area is currently statically configured, but be driven by opt-in 'share my location' app.

#### Notification methods
+ Sending Tweets
+ Sending Direct Messages
+ Sending emails

#### Posting Tweets

An example use-case is having a weather station Tweet its readings. Another would be sending a private direct message to provide another device an 'event' to act on. 

Posting Tweets is very straightforward on the Raspberry Pi. Languages such as Python, Ruby, and Java all have great resources for Tweeting. 

##### Sending Direct Message

[] Updates.

An example use-case is . Another would be sending a private direct message to provide another device an 'event' to act on. 

Sending Direct Messages (DMs) is similar to posting Tweets on the Raspberry Pi. Languages such as Python, Ruby, and Java all have great resources for Tweeting.

##### Sending Email

An example use-case is emailing a group when a gauge hits a actionable threshold.  Another is to email a IFTTT server to trigger some other remote process.  

Sending emails is simple in all languages and most OSs. You'll probably want a SMTP service of some kind.

[] Set up SMTP service. 


## Listening /listen <a id="listen" class="tall">&nbsp;</a>

The ability to listen for Tweets of interest. Tweet attributes of interest may include #hashtags, @accounts, URLs, keywords, and location.

The focus here will be listening for Tweets from a flood warning system account in an area of user interest.  









## Other Random Thoughts <a id="articles" class="tall">&nbsp;</a>

### Challenges of low-volume streams <a id="low-volume-streams" class="tall">&nbsp;</a>

When considering challenges related to streaming Twitter data, managing high data volumes is the one that first comes to mind. When Gnip customers have issues with maintaining a stream connection, it usually is due to not keeping up and experiencing a forced disconnect after the server-side buffer fills up. When forced disconnects are happening, the go-to advice, after confirming network environment is up to the task, is to focus on the stream consumer object.

A stream consumer object is the app that makes a GET request to start the stream, then listens for data coming across a socket connection. As it receives the simple UTF-8 JSON text, it assembles whole JSON Tweets and put them on a queue. That's really it. Sure, there are plenty of coding details wrapped up in that quick generalization, but conceptually the process is simple.

The stream consumer should not be doing a lot of 'heavy-lifting', not parsing JSON, not applying any logic, but instead is just writing received data to a queue... 

*"As a stream consumer, how do I start to confirm my network environment is up to the task?"* -- a solid plan is to create rules that will be used in production (or a best guess for the rule set), and run something simple and efficient like cURL and stream your data for a while. *How long is a while?"* Depends. At least an hour or so before getting too serious about other high-volume streaming, like downstream queues, data store, and the wild world of web UIs.

With the type of use-case I had in mind for the raspberry pi, I experienced a challenge due to the opposite scenario: very low volume streams. I needed to build a stream consumer that could receive very low amounts of data, such as one Tweet every hour or so. When I first tested with such a low-volume stream, I used the EventMachine-based Ruby consumer mentioned above. I started the stream consumer, and Tweeted the \#iot_test hashtag and waited... and waited... and waited. Nothing happened. I was expecting the normal second or so latency between posting the Tweet and see it arrive in my app. After about five minutes, I added a high-volume filter to my PowerTrack stream and immediately after saw the \#iot_test Tweet arrive. Turns out it was hanging out in a client-side streaming buffer until enough subsequent Tweets arrived and pushed it out of that buffer... 

One solution here is to dig into the EventMachine code and tinkering with its internal buffers. Before doing that, I decided to experiment with a cURL-based Ruby stream consumer (used the curb gem) under the assumption that since it was based on cURL that there may not be any buffering issue. This potentially naive assumption was based on my experience with cURL and always seeing low latency with low-volume streams. 

So I took the Gnip simplistic curb-based Ruby code snippet, and sure enough, it handled the low-volume stream perfectly, 'surfacing' a single Tweet as fast as pure cURL. The downside of that code-based is its simplicity, with no logging, no configuration management, and no delivery of whole-Tweet, but rather generating data with Tweets sometimes split between data chunks. However, I hit a roadblock when attempting to deploy the curb-based app on the Raspberry Pi. I was unable to get the curb gem installed on the Raspbery Pi 3... 

After following a few 'install curb' recipes with no success, the next step was testing other stream consumers. I spun up a Python gnippy-based stream, and got the low-volume handling I was looking for. My single Tweet showed up in about a second. 

So, chalk one up for Python, but not for Ruby. (Here's a mental to-do that tweaking EventMachine to handle low volumes, or if it should already do that, fix how I am using it.) I hope to get back and do another round of Ruby low-volume streams, but for now I am happy to run with a Python 'listener' to move on to the next component, the 'notification manager.'


### Building a simple Twitter Responder <a id="twitter-responder" class="tall">&nbsp;</a>

So, I finally had both a low-volume-ready listening app and a Tweeting app deployed and running on the Pi. Even though this was a Python-based consumer and a Ruby-based Tweeter, it seemed like a fun idea to make these pieces work together. The consumer and Tweeting apps are being deployed as separate processes, so the underlying language shouldn't matter. For the first, all-Ruby curb-based attempt, the Ruby ``` `#{command}` ``` mechanism seemed to do the job. For the Python-calling-Ruby process, I went with the Python ```subprocess.check_output()``` method. See the code [HERE](https://github.com/jimmoffitt/pi-adventures/blob/master/py-stream-pi.py).

This plumbing worked out of the (pi) box. I had a simple Twitter Bot runnning on a Raspbery Pi 3.

So a Tweet like this with a 'trigger' hashtag:

 ![](https://github.com/jimmoffitt/pi-adventures/blob/master/images/triggerTweet.jpg)
 
Results in this Tweet:

  ![](https://github.com/jimmoffitt/pi-adventures/blob/master/images/responseTweet.jpg)
  
  
  
 
### Conference Demos, mixed blessings. <a id="conference-demos" class="tall">&nbsp;</a>

The last round of pi adventures was in preparation for a hydrology conference in Albany NY in September 2016. The conference attendees had a high chance of being accustom to tinkering with instrumentation, primarily in the efforts of flood warnings. There would be a common, shared experience of having played with remote dataloggers, collecting meteorlogical data, and sending notifications. 

I'd prepared a set of demos, based on the code above. Simple stuff: have someone Tweet with #IoTflood and they receive an automated response within a few seconds. The real point of the demo was to be that all of this was happening on a $35 computer with the size of a bar of soap. Another key point was the lack of latency between a 'request' Tweet, and the 'response' Tweet. Receiving a response in a few seconds should resonate with this audience. I'd done some testing, it seemed to work great, and I was looking forward to showing off the potential for the Twitter network to be an important public channel of public safety communication. 

When I'd cranked up the demo up at the podium, in front of about 60 people, my Raspberry Pi 3 was asking what OS to install. My Pi's 'image' was gone. I was booting up a fresh Pi 3 with none of the installs, gems, packages, configurations that I'd built essentially by hand. After a few minutes of rebooting and making demo jokes, the presentation went on. Luckily I had 60 minutes and lots of other material, so it all ended fine. 

My 'Tweeting in the Rain' talks have spent considerable time on both the "why" and "how" of integrating Twitter with early-warning systems. Early on (way back in 2012!) the focus was on the 'why' at conferences where social media was not a primary focus. I first presented on the topic of Twitter and flood warning systems in 2013. The hydrologic warning conference did not have a 'social media' track, and our talk was on the challenges and opportunities of integrating Twitter. Most of the material was based on parts 1-3 of this series of Gnip blog posts. Part 3 was posted approximately 10 hours before Boulder County was at the start of an historic flood. See Part 4 to see how the 2013 Colorado flood unfolded on Twitter. 

Now it's April 2017, and I am starting to prepare for another conference (or two?) in June and it is time to start climbing the demo hill again. The great hope is that the above recipes will enable me to quickly catch up to where I was before, and then have the foundation to build on. Thanks to recent Twitter Platform updates, an even more compelling demo can be designed. Since last September, there have been many Twitter platform updates (in fact exciting stuff is being announced on a weekly basis it seems) that brings new communication tools to domains of all stripes. 

For the world of early-warning systems, these new skills include sending direct messages to subscribers, and enabling those subscribers to share their locations (with a [feature announced yesterday](https://blog.twitter.com/2017/businesses-can-now-share-and-request-locations-in-direct-messages)).

I have fifty-eight days until the next conference. I better get cracking. 














### Searching Tweets
TBD


## Play notes ---------------------

[] Next?
[] Storing data? Mongo? Flat-files?
[] DM API 


## Project design details

[] Set-up listening for Austin area gauges.
[] When they Tweet, have @iot_tweeter tweet.
[] Then send me an email... 
[] That's it.


[] Listening details:
[] All rules have from: clause
[] All rules have geo-clause
[] All rules have domain specific hashtags, keywords, and urls.

from:USGSTexas_Flood 
profile_region:TX profile_locality:Austin
point_radius:[-97.7435 30.2678 25mi] 

Domain attributues:
  keywords: "Flood,Rain,Storm,Damage,Help"
  hastags: "#txwx,#usgs" 






[] Stub out Rules API client that deletes and re-sends stream with geo-rule. 



## Pi 3 and code *environments*

Ruby

Rebuilding the Ruby environment, twice now, seems like a total PITA. 


Python


Node



## Posting Data 

### Python and Twitter API

Have Tweeted with these two packages. No issues with getting started.

+ sudo pip install twython
+ sudo pip install tweepy 
 
[Example Tweepy code](https://github.com/jimmoffitt/pi-adventures/blob/master/notify/tweet/post_tweet.py)


### Ruby and Twitter API

Have Tweeted with the 'twitter' gem. Needed to install bundler and do a fresh ruby install. 

+ gem install bundle (ah, helps to have a Gemfile for this...)
+ sudo apt-get install ruby-full
+ gem install twitter 
 
 + [sudo apt-get install ruby-full] fails with hint to apt-get update (which went well).
 + That hint seemed to help ;)
 
 [Example code](https://github.com/jimmoffitt/pi-adventures/blob/master/notify/tweet/post_tweet.rb) 
   + Note: failed to build native extensions before the previous ruby install.





## Consuming data from Gnip

The use-case driving these experiments is enabling a device to listen for Twitter events, and notify a remote subscriber of an event... 

Data can be received by either making polls on some interval, or streaming in realtime.


### High-level developer summary

+ Tweets encoded on JSON. JSON written with UTF-8 character sets.
+ Example code is based on 'original' JSON format. Referred to by Gnip products as 'original' format. If you are more accustom to the 'activity format (AS)' format, any parsing details should be relatively easy to convert to the original format. See [HERE]() for more details.

+ Polling systems based on Gnip Search APIs (or Twitter public APIs) should be relatively easy to set-up.
    + Need poll managers.
+ Realtime streaming may be overkill but seems like an interesting POC, enabling realtime control with low latency.

## Restful Search APIs

[] TODO

## Realtime Streaming APIs

Gnip Streaming was a bit more challenging, but we got there.

### Python streaming

+ [gnippy](https://pypi.python.org/pypi/gnippy) more or less worked straight out of the box. [Example code](https://github.com/jimmoffitt/pi-adventures/blob/master/listen/stream/gnippy-stream.py).
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


## Java examples

[] TODO - Java stream consumer?



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




## Part 2:

### "things I learned from the Pi crash of 2016"

So, I would be re-doing these efforts a second time, but this time a bit differently. My previous experiments would this time morph into best-practices. On top of that advancement, the above documentation would revisisted, tested, fixed and hopefully enhanced. 

+ Make back-ups of Pi SD card. 
+ Verify that packages, gems and other environmental pieces are readily available and ready to roll. Start making installs, and make sure things like gemset files are up-to-date and actually helpful.
+ Make 'laptop-dev' --> 'pi-test' iteration easier, faster.


## Random notes:

### Demo version 1
+ [] Deploy python and ruby listeners.
+ [] Trigger a Tweet from IoT account.

### Demo version 2

+ [] Listen for Tweets: #IoTflood, from:dataSource, Geo-based ("tunable from remote server")
+ [] Send Tweet from IoT account
+ [] Send DM to small target list 
+ [] and/or send email

+ [] Subscriber selects area of interest, receives DM when area sensor Tweets. 



### A snow day's off worth of to-dos

+ [] Rebuild Pi Ruby and Python environments (with above recipes)
    + 
+ [] Clone/update laptop repository.

+ [] Random code updates:
    + [] adding config file to ruby example (instead of hardcoding consumer code with keys).

+ [] Synch Pi with github respository.
    + [] git clone https://github.com/jimmoffitt/pi-adventures.git
    
### code notes.







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

#### Pi Power Requirements

 	      Pi1 (B+)	Pi2 B	Pi3 B (Amps)	Zero (Amps)
Boot	Max	0.26	0.40	0.75	          0.20
        Avg	0.22	0.22	0.35	          0.15

Idle	Avg	0.20	0.22	0.30	          0.10

Stress	Max	0.35	0.82	1.34	          0.35
        Avg	0.32	0.75	0.85	          0.23







