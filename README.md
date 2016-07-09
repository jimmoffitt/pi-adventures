# adventures in pi

A collection of notes about setting up a Raspberry Pi 3 for posting and collecting Twitter data. So far playing with Ruby, Python and Java. Node.js should be on this list too. 

Covers two-way communication, posting messages to the outside world, and listening for messages. 

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
