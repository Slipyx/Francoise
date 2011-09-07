--[[
Copyright (c) 2011 Josh Koch

This software is provided 'as-is', without any express or implied warranty. In
no event will the authors be held liable for any damages arising from the use
of this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to
the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim
that you wrote the original software. If you use this software in a product, an
acknowledgment in the product documentation would be appreciated but is not
required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
--]]

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
	print("Connecting...")
	s:connect(CONNECTION)
	print("Joining...")
	for i = 1, #CHANNELS do
		s:join(CHANNELS[i])
	end
end

Connect()

-- Hooks
-- Don't know if this will handle reconnects
s:hook("OnDisconnect",
	function(message, errorOccurred)
		print("Disconnected!", message, errorOccurred)
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
