# First, install some necessary packages. If you have already done this, you do not need to do it again.

install.packages('tm')
install.packages('RSQLite')
install.packages('ggplot2')

# Now let's import the libraries

library("RSQLite")
library("tm")
library(ggplot2)

# DEPRECATING THIS PART. LEAVING IT FOR NOW. 

# First, let's connect to our database. We do this by creating a variable called con, and populate it with the connection. Be sure to change the path to your database.

con <- dbConnect(drv="SQLite", dbname="/Users/mwaite/Dropbox/Documents/writing/Poynter/TweetsWithR/tweets.db")

# If you're skeptical, you can take a look at the tables. There's only one.

tables <- dbListTables(con)

# While databases like tables, R doesn't. It likes things as dataframes. So we need to make our table into a dataframe.

tweetframe <- dbReadTable(con, "tweets")

# END DEPRECATION

# The basic data unit of text analysis is the lexical corpus. It's a dataset of documents. We'll create it here.

tweetframe.corpus <- Corpus(VectorSource(tweetframe))

# To work with that corpus, we need to clean it up. This is pretty easy to follow, but we're first going to make everything lowercase.

tweetframe.corpus <- tm_map(tweetframe.corpus, tolower)

# Now let's remove punctuation so "term" and "term." are not two different things.

tweetframe.corpus <- tm_map(tweetframe.corpus, removePunctuation)

#If you're dealing with text that has urls in it, you're going to create strange numbers like 20031112 in them. That's a date from a url. It pops out when we strip the punctuation. We should strip those too.

tweetframe.corpus <- tm_map(tweetframe.corpus, removeNumbers)

# Now let's remove all stop words. Stop words are things like "a", "and", "the", "of" and the like. We just want high value words. And, since the word you searched for by definition has to appear in every tweet, lets remove it too so we can see other relationships. In my case, the word was drone, which also popped up drones.

customstopwords <- c(stopwords('english'), 'drones', 'drone')

tweetframe.corpus <- tm_map(tweetframe.corpus, removeWords, stopwords("english"))

# Let's explore our dataset now, first by creating a document term matrix (dtm). It gives you a list of terms that appear in the corpus. Warning: The bigger your dataset, the longer this takes. On 225,000 tweets, you have time for a cup of coffee on a MacBook Pro.

tweetframe.dtm <- TermDocumentMatrix(tweetframe.corpus)

# Now, *every* term is probably not useful. Some appear more than others. Here's how to show only terms that appear 30 or more times. The more words your corpus has, the higher this number will need to be. For 225,000 tweets, I set it at 2,000 and got some interesting results.

findFreqTerms(tweetframe.dtm, lowfreq=30)

# So let's visualize this. Let's build a bar chart that shows how many time each of these terms appears in the corpus. First, we need to create a dataframe that the ggplot2 library will take. First, we'll do it for the whole document term matrix.

termFrequency <- rowSums(as.matrix(tweetframe.dtm))

# Now, since we don't need everything, lets make a subset.

termFrequency <- subset(termFrequency, termFrequency>=2000)

# And now make it a bar chart, on it's side for easier reading.

qplot(names(termFrequency), termFrequency, geom="bar", xlab="Terms") + coord_flip()
