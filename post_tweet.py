#!/usr/bin/env python2.7
import tweepy
import sys

# Consumer keys and access tokens, used for OAuth
# consumer_key = ''
# consumer_secret = ''
# access_token = ''
# access_token_secret = ''

# OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
 
# Creation of the actual interface, using authentication
api = tweepy.API(auth)

if len(sys.argv) >= 2:
    tweet_text = sys.argv[1]
else:
    tweet_text = "Tweeting from a Raspberry Pi 3 with python and tweepy is easy enough... "

api.update_status(status=tweet_text)
