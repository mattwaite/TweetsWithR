"""

A set of python functions to help you store tweets gathered from a Twitter search in a SQLite database for later analysis.

Requires python-twitter, but you can sub out your own method to query Twitter's API.

"""

# Import the parts needed
import sqlite3, twitter, time, string, os.path
from datetime import datetime

# A function to create the table needed to 
def create_table():
    # Connect to the database
    conn = sqlite3.connect('tweets.db')
    # Create a cursor
    c = conn.cursor()
    # Create the table. Mmmmmm, SQL.
    c.executescript('''CREATE TABLE tweets(
        "id" integer NOT NULL PRIMARY KEY, 
        "tweet_id" bigint NOT NULL, 
        "created_date" datetime NOT NULL,
        "text" text NOT NULL,
        "screen_name" varchar(100) NOT NULL);''')
    print "Table created"
        
def insert_tweets():
    # Create an instance of the Twitter API
    api = twitter.Api()
    # Create a connection to our database
    conn = sqlite3.connect('tweets.db')
    c = conn.cursor()
    # Create a list of pages that we can iterate over. Think of this as the pagination list at the bottom of the search page, because that's exactly what it is.
    page = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    # Create an iterator
    for iteration in page:
        # Query the search API. The search term is in the quotes, per_page means how many tweets do you want when you get the page, and the page is the page in the paginator.
        tweets = api.GetSearch("drones", per_page=100, page=iteration)
        # Now we're going to loop through our list of tweets.
        for tweet in tweets:
            # But wait -- we don't want duplicates! So lets check if it exists in the database first. First, lets get the ID of the tweet.
            tid = long(tweet.id)
            # Now, lets write some SQL.
            c.execute('SELECT * FROM tweets WHERE id=?', (tid,))
            # The logic here is a little backwards. It says if you get something when you execute our SQL, that means it already exists, so continue on. If you DON'T get something, lets insert some tweets.
            if c.fetchone():
                continue
            else:
                # Dates are a pain in the ass because no one agrees on how to store them. So these lines just deal with that and turn them into python date objects that we can deal with in a civilized manner.
                tweet_date = tweet.created_at
                # Parse the date and time
                tweet_date = time.strptime(tweet_date, "%a, %d %b %Y %H:%M:%S +0000")
                # Reassemble as python datetime object
                tweet_date = datetime(tweet_date.tm_year, tweet_date.tm_mon, tweet_date.tm_mday, tweet_date.tm_hour, tweet_date.tm_min, tweet_date.tm_sec)
                user = tweet.user.screen_name
                tweet_text = tweet.text
                # Now insert it into the database
                c.execute('INSERT INTO tweets(tweet_id, created_date, text, screen_name) VALUES (?,?,?,?)', (long(tweet.id), tweet_date, tweet_text, user))
        # Now, because we're decent people, we're going to give Twitter's servers a break. Leaving a few seconds between requests is just good etiquette when scraping or pulling data from an API. Here, we leave three seconds between requests.
        time.sleep(3)


# Now it's party time. Here were're going to check if we've got a database called tweets.db, and if we don't, call the function to create it and then call the function to shove some tweets in it. If it DOES exist, lets just call the function to shove tweets in it.

if os.path.exists("tweets.db"):
    insert_tweets()
else:
    create_table()
    insert_tweets()