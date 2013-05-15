First, install some necessary packages:

> install.packages('tm')
> install.packages('RSQLite')

Now let's import the libraries

> library("RSQLite")
> library("tm")

First, let's connect to our database. We do this by creating a variable called con, and populate it with the connection. Be sure to change the path to your database.

> con <- dbConnect(drv="SQLite", dbname="/Users/mwaite/Dropbox/Documents/writing/Poynter/TweetsWithR/tweets.db")

If you're skeptical, you can take a look at the tables. There's only one.

> tables <- dbListTables(con)

While databases like tables, R doesn't. It likes things as dataframes. So we need to make our table into a dataframe.

> tweetframe <- dbReadTable(con, "tweets")


 
> tweetframe.corpus <- Corpus(VectorSource(tweetframe))

> tweetframe.corpus <- tm_map(tweetframe.corpus, tolower)

> tweetframe.corpus <- tm_map(tweetframe.corpus, removePunctuation)

> tweetframe.corpus <- tm_map(tweetframe.corpus, removeWords, stopwords("english"))

> tweetframe.dtm <- TermDocumentMatrix(tweetframe.corpus)

> tweetframe.dtm

> findFreqTerms(tweetframe.dtm, lowfreq=30)

> findAssocs(tweetframe.dtm, 'drone', 0.20)

> tweetframe.dtm2 <- removeSparseTerms(tweetframe.dtm, sparse=0.95)

