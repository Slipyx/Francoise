-- config.lua

CONNECTION = {
	host = "irc.acid.net",
	port = 7000,
	timeout = 30,
	secure = true,
}

CHANNELS = {
	"#ganymede",
}

USER = {
	nick = "Francoise",
	username = "ed",
	realname = "Edward",
}

-- List of feeds to check
-- name = name of feed, url = feed url, t = check interval in seconds, c = title color "FG,BG" or "FG" or "" for no color
FEEDS = {
	{name = "Reddit", url = "http://www.reddit.com/.rss", t = 600, c = "5"},
	{name = "r/gaming", url = "http://www.reddit.com/r/gaming/.rss", t = 600, c = "12"},
	{name = "r/gamedev", url = "http://www.reddit.com/r/gamedev/.rss", t = 600, c = "11"},
	{name = "BBC", url = "http://feeds.bbci.co.uk/news/rss.xml", t = 600, c = "0,1"},
	{name = "TMZ", url = "http://www.tmz.com/rss.xml", t = 600, c = "1,5"},
	{name = "Slashdot", url = "http://rss.slashdot.org/Slashdot/slashdot", t = 600, c = "9"},
	{name = "CNN", url = "http://rss.cnn.com/rss/cnn_topstories.rss", t = 600, c = "5,0"},
	{name = "Digg", url = "http://services.digg.com/2.0/story.getTopNews?type=rss", t = 600, c = "9,0"},
	{name = "Gizmodo", url = "http://feeds.gawker.com/gizmodo/full", t = 600, c = "0,10"},
}
