There's a lot of talk about people "mining" Twitter, and the vast bulk of that talk that you can find online can be lumped into two camps:

* What, in ye olden days, we would have called "eyeballing it." Set up Tweetdeck hashtag search, sit back and watch.
* Opaque references to "sophisticated" methods that you, pat on head, wouldn't understand so pay us money.

You can find way more of the first type than the second in journalism circles. But, the truth is, the second type is less difficult than you might think. Especially if you look for help in the world of Digital Humanities. Digital Humanities, to greatly oversimplify, is bringing programming, math and other computer tools to the worlds of literature, history, writing and other humanistic pursuits. Every time I listen to my digital humanist friends talk, I become more convinced that modern journalism and digital humanities were twins, separated at birth and put on slightly different life paths. The crossovers are so obvious and powerful.

So how might we go about doing more sophisticated analysis of Twitter traffic? There are loads of examples online, but many of them are tailored to specific audiences or are using libraries that have been discontinued. And, I like to use experiments like this to work with new tools, so here's what we're going to do.

* First, we're going to write a Python script that goes to Twitter, runs a search, and gets 1,500 tweets at a time on a topic. Python is a commonly installed library on most computers, so setting it up to run every hour is pretty easy.
* We'll take those tweets and store them in a SQLite database. Worried you don't have SQLite? Don't. If you have Firefox installed, you've got SQLite. And, with Firefox, you can have a tool to read the database. All for free.
* To analyze that database, we'll use R, a stats language that has a little bit of a learning curve, but is exceptionally powerful, free and tremendously documented on the web. 