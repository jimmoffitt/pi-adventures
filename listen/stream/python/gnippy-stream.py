#!/usr/bin/env python
import time
from gnippy import PowerTrackClient

# Define a callback
def callback(activity):
    print activity

# Create the client
client = PowerTrackClient(callback,url="https://stream.gnip.com:443/accounts/{ACCOUNT_NAME}/publishers/twitter/streams/track/{STREAM_LABEL}.json",auth=("me@there.com","nOtMyPaSsWoRd"))
print "Connecting..."
client.connect()
time.sleep(1800) #run for 30 minutes... 
client.disconnect() #... then disconnet.

print "finished streaming, exiting..."
