-- config.lua

CONNECTION = {
	host = "irc.freenode.net",
	port = 7000,
	timeout = 30,
	secure = true,
}

CHANNELS = {
	"#foobar",
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
}
