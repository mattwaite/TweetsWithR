# First, install some necessary packages:

install.packages('tm')
install.packages('RSQLite')

# Now let's import the libraries

library("RSQLite")
library("tm")

# First, let's connect to our database. We do this by creating a variable called con, and populate it with the connection. Be sure to change the path to your database.

con <- dbConnect(drv="SQLite", dbname="/Users/mwaite/Dropbox/Documents/writing/Poynter/TweetsWithR/tweets.db")

# If you're skeptical, you can take a look at the tables. There's only one.

tables <- dbListTables(con)

# While databases like tables, R doesn't. It likes things as dataframes. So we need to make our table into a dataframe.

tweetframe <- dbReadTable(con, "tweets")

# The basic data unit of text analysis is the lexical corpus. It's a dataset of documents. We'll create it here.
 
tweetframe.corpus <- Corpus(VectorSource(tweetframe))

# To work with that corpus, we need to clean it up. This is pretty easy to follow, but we're first going to make everything lowercase.

tweetframe.corpus <- tm_map(tweetframe.corpus, tolower)

# Now let's remove punctuation so "term" and "term." are not two different things.

tweetframe.corpus <- tm_map(tweetframe.corpus, removePunctuation)

# Now let's remove all stop words. Stop words are things like "a", "and", "the", "of" and the like. We just want high value words.

tweetframe.corpus <- tm_map(tweetframe.corpus, removeWords, stopwords("english"))

# Let's explore our dataset now, first by creating a document term matrix (dtm). It gives you a list of terms that appear in the corpus.

tweetframe.dtm <- TermDocumentMatrix(tweetframe.corpus)

# Wanna see it?

tweetframe.dtm

# Now, *every* term is probably not useful. Some appear more than others. Here's how to show only terms that appear 30 or more times. The more words your corpus has, the higher this number will need to be.

findFreqTerms(tweetframe.dtm, lowfreq=30)

# Not exactly sure what this does and certainly can't explain it. So more research here plz.

findAssocs(tweetframe.dtm, 'drone', 0.20)

# Same. It removes sparse terms to make life easier and puts it into a new dataframe. But I'm not sure what the .95 means yet. So, more here plz.

tweetframe.dtm2 <- removeSparseTerms(tweetframe.dtm, sparse=0.95)
