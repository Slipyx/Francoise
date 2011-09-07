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

require(cfgFile)
local http = require("socket.http")
require("luaxml")
local dateUtils = require("dateUtils")
local log = require("logger").log

local function GetDate(item)
	local pubDate = item:find("pubDate") or item:find("dc:date") or item:find("updated")
	if not pubDate then log("PUBDATE NOT FOUND!") return end
	pubDate = pubDate[1]
	if string.sub(pubDate, 1, 1) == "2" then pubDate = dateUtils.DcToPub(pubDate) end
	return pubDate
end

local function CheckFeed(s, curFeed)
	-- Check feed
	log(string.format("Checking (%d) %s...", curFeed, FEEDS[curFeed].name))
	local xmlTxt
	local c = 1
	while xmlTxt == nil and c < 5 do
		log("Attempt #" .. c .. "...")
		xmlTxt = http.request(FEEDS[curFeed].url)
		c = c + 1
	end c = nil
	if not xmlTxt then log("CHECK FAILED!") return end
	local xml = xml.eval(xmlTxt)
	local xchannel =  xml:find("rdf:RDF") or xml:find("channel") or xml:find("feed")
	local xitems = {}
	if xchannel ~= nil then
		for i = 1, #xchannel do
			if xchannel[i][0] == "item" or xchannel[i][0] == "entry" then
				table.insert(xitems, xchannel[i])
			end
		end
	end
	xchannel = nil

	local xnewItems = {}
	for i = 1, #xitems do
		local pubDate = GetDate(xitems[i])
		if not pubDate then return end
		if dateUtils.DateIsNewer(FEEDS[curFeed].lastDate, pubDate) then
			table.insert(xnewItems, xitems[i])
		end
		pubDate = nil
	end
	-- Print all new ones
	for i = #xnewItems, 1, -1 do
		local pubDate = GetDate(xnewItems[i])
		if not FEEDS[curFeed].firstTime then
			local link = xnewItems[i]:find("link")[1] or xnewItems[i]:find("id")[1]
			log("NEW " .. FEEDS[curFeed].name .. " ITEM!")
			for j = 1, #CHANNELS do
				s:sendChat(CHANNELS[j], string.format("%s%s: %s <15%s>", FEEDS[curFeed].c, FEEDS[curFeed].name, xnewItems[i][1][1], link))
			end
			link = nil
		end
		if dateUtils.DateIsNewer(FEEDS[curFeed].lastDate, pubDate) then
			FEEDS[curFeed].lastDate = pubDate
		end
		pubDate = nil
	end
	log(FEEDS[curFeed].name .. " newest date: " .. FEEDS[curFeed].lastDate)
	print()
	FEEDS[curFeed].firstTime = nil
end

return { CheckFeed = CheckFeed }
