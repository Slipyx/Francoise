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

-- Parse command line arguments
for i = 1, #arg do
	if arg[i] == "--config" then cfgFile = arg[i + 1] end
end
if not cfgFile then cfgFile = "config" end

require("irc")
local sleep = require("socket").sleep
require(cfgFile)
local timer = require("hump.timer")
local feedParser = require("feedParser")
local log = require("logger").log

-- Frame time vars
local tt = 0
local dt = 0
-- IRC user
log("**** BOT START ****")
local s = irc.new(USER)

local Reconnect = 0 -- Forward declare

local function Connect()
    while s == nil do
        log("Creating new user...")
        s = irc.new(USER)
    end
    --s:hook("OnRaw", function(line) log(line) end) -- Raw logging
	log("Connecting...")
	if not pcall(s.connect, s, CONNECTION) then
        Reconnect("Connect attempt failed!", true)
    else
        s:hook("OnDisconnect", Reconnect)
        log("Joining...")
        for i = 1, #CHANNELS do
            log("    " .. CHANNELS[i])
            s:join(CHANNELS[i])
        end
        print()
    end
end

Reconnect = function(message, errorOccurred)
    log("Disconnected!", message, errorOccurred)
    s = nil
    sleep(4)
    Connect()
end

Connect()

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
	sleep(1)
	dt = os.clock() - tt
end
