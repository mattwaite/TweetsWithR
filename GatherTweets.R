# First, install some necessary packages. If you have already done this, you do not need to do it again.

install.packages("twitteR") # this will install all the needed other packages

#import the libraries

library("twitteR")
library("ROAuth")

#None of this works. Working on that.

credential <- OAuthFactory$new(consumerKey="1EOwSDqbh7jLsVVIhCg",
                               consumerSecret="Fv7NjwFMoiJgCFL20ZZmGRdA0pEfGDbDKiZIOUPpI",
                               requestURL="https://api.twitter.com/oauth/request_token",
                               accessURL="https://api.twitter.com/oauth/access_token",
                               authURL="https://api.twitter.com/oauth/authorize")



