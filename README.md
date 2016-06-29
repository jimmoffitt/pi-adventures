# pi-adventures

A collection of notes about setting up a Raspberry Pi 3 for posting and collecting Twitter data. So far working with Ruby, Python and Java. 

Covers two-way communication, posting messages to the outside world, and listening for messages. 

## Posting Data

Posting data enables the Pi device to communicate to the outside world. Messages can be public via Tweets or private via Direct messages. An example use-case is having a weather station Tweet its readings. 

### Python and public Twitter API

Have Tweeted with these two packages. No issues with getting started.

+ sudo pip install twython
+ sudo pip install tweepy

### Ruby and public Twitter API

Have Tweeted with the 'twitter' gem. Needed to install bundler and do a fresh ruby install. 

+ gem install bundle
+ sudo apt-get install ruby-install
+ gem install twitter  (failed to build native extensions before the previous ruby install)

### Java example

[] TODO


## Consuming data

The use-case driving these experiments is enabling a device to listen for commands via Twitter. Data can be received by either making polls on some interval, or streaming in realtime. Realtime streaming may be overkill but seems like an interesting POC, enabling realtime control with low latency.

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

+ [] gnippy
+ [] ????
