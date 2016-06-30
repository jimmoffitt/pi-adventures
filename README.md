# adventures in pi

A collection of notes about setting up a Raspberry Pi 3 for posting and collecting Twitter data. So far playing with Ruby, Python and Java. Node.js should be on this list too. 

Covers two-way communication, posting messages to the outside world, and listening for messages. 

The general use-case to help provide data stories is based on both integrating Twitter with early-warning systems and investigating the history of the use of Twitter during historic floods. These applications of Twitter data and the Twitter platform have provided a great variety of user and data stories to share.

Early warning systems are based on meterological data collection systems and the public safety mission of providing alarms and notifications. These systems can readily add Twitter as a broadcast channel, and have the potential to listen for Tweets of interest. 


## Posting Data

Posting data enables the Pi device to communicate to the outside world. Messages can be public via Tweets or private via Direct messages. An example use-case is having a weather station Tweet its readings. Another would be sending a private direct message to provide another device an 'event' to act on. 

Posting Tweets (and Direct Messages) is very straightforward on the Raspberry Pi. Languages such as Python, Ruby, and Java all have great resources for Tweeting. 

## Consuming data from Gnip

For these experiments, Gnip was the go-to source for data for a couple of reasons. First, many of the packages/gems used above to Tweet also support streaming data. Second, Gnip provides enterprise-grade data services that provide performance, data fidelity, and reliability demanded by early-warning systems.

Gnip focuses on the delivery of Twitter data and metadata, and provides a family of products that help users filter the realtime firehose or all-time archive for Tweets of interest. Gnip provides both RESTful APIs able to retrieve data on a near realtime basis and realtime streaming APIs that deliver data with minimum latency. 

[] add summary of streaming success


## Play notes ---------------------


## Posting Data 

### Python and Twitter API

Have Tweeted with these two packages. No issues with getting started.

+ sudo pip install tweepy ([example code](https://github.com/jimmoffitt/pi-adventures/blob/master/post_tweet.py))
+ sudo pip install twython

### Ruby and Twitter API

Have Tweeted with the 'twitter' gem. Needed to install bundler and do a fresh ruby install. 

+ gem install bundle
+ sudo apt-get install ruby-install
+ gem install twitter ([example code](https://github.com/jimmoffitt/pi-adventures/blob/master/post_tweet.py))  
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

Gnip Streaming seems a bit more challenging.

### Ruby pt-stream

+ Resurrected an early attempt at a Ruby multi-publisher stream consumer.
+ Refactoring it for both Pi and ptv2.
   + Removing mysql support. Will port to something much more light-weight.
   + Removing support for non-Twitter publishers. Removed code only supported annoying and simple differences in encoding metadata (like activity ids, geo details, even timestamps -- thanks StockTwits).

Deployed on Pi:
+ getting error about "Encryption not available on this event-machine"

```
pi@raspberrypi:~/play/pt-stream-pi $ ruby pt_stream_pi.rb
terminate called after throwing an instance of 'std::runtime_error'
  what():  Encryption not available on this event-machine
Aborted
```
   

### Java HBCpt2

Seems like pi in the sky at this point. Currently attempting to deploy by hand the [HBC udpated for ptv2](https://github.com/jimmoffitt/hbc).

+ Read up on installing a full horsepower IDE (IntelliJ specifically), but seems that would be overkill. 
+ Have deployed compiles classes on Pi, but external libraries are not found.
+ Playing around with $PATH, so far to no avail. 


### Python streaming

+ gnippy more or less worked straight out of the box.
+ [] ????
