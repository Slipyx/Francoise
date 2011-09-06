require("irc")
local sleep = require("socket").sleep
require("config")
local timer = require("hump.timer")
local feedParser = require("feedParser")

-- Frame time vars
local tt = 0
local dt = 0
-- IRC user
local s = 0

local function Connect()
	s = irc.new(USER)
	s:connect(CONNECTION)
	for i = 1, #CHANNELS do
		s:join(CHANNELS[i])
	end
end

Connect()

-- Hooks
-- Don't know if this will handle reconnects
s:hook("OnDisconnect",
	function(message, errorOccurred)
		s = nil
		sleep(4)
		Connect()
	end
)
--s:hook("OnRaw", function(line) print(line) end)

-- Setup feed checker intervals
for i = 1, #FEEDS do
	FEEDS[i].lastDate = "Mon, 01 Jan 1970 00:00:00 UTC"
	FEEDS[i].firstTime = true
	feedParser.CheckFeed(s, i) -- Check on start to get newest date
	timer.addPeriodic(FEEDS[i].t, function() feedParser.CheckFeed(s, i) end)
end

-- Main Loop
while true do
	tt = os.clock()
	s:think()
	timer.update(dt)
	sleep(0.5)
	dt = os.clock() - tt
end
