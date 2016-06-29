# pi-adventures


## Python and public Twitter API
sudo pip install twython
sudo pip install tweepy

## Ruby and public Twitter API

+ gem install bundle
+ sudo apt-get install ruby-install
+ gem install twitter  (failed to build native extensions before the previous ruby install)


## Streaming

### Ruby pt-stream

+ Resurrected an early attempt at a Ruby multi-publisher stream consumer.
+ Refactoring it for both Pi and ptv2.
   + Removing mysql support. Will port to something much more light-weight.
   + Removing support for non-Twitter publishers. Removed code only supported annoying and simple differences in encoding metadata (like activity ids, geo details, even timestamps (thanks GetGlue).

Deployed on Pi:
+ getting error about "Encryption not available on this event-machine"
   


### Java HBCpt2

Seems like pi in the sky at this point. Currently attempting to deploy by hand the [HBC udpated for ptv2](https://github.com/jimmoffitt/hbc).

+ Read up on installing a full horsepower IDE (IntelliJ specifically), but seems that would be overkill. 
+ Have deployed compiles classes on Pi, but external libraries are not found.
+ Playing around with $PATH, so far to no avail. 


