require("config")
local http = require("socket.http")
require("luaxml")
local dateUtils = require("dateUtils")

local function CheckFeed(s, curFeed)
	-- Check feed
	print(string.format("Checking (%d) %s...", curFeed, FEEDS[curFeed].name))
	local xmlTxt
	local c = 1
	while xmlTxt == nil and c < 5 do
		print("Attempt #" .. c)
		xmlTxt = http.request(FEEDS[curFeed].url)
		c = c + 1
	end c = nil
	if not xmlTxt then print("CHECK FAILED!") return end
	local xml = xml.eval(xmlTxt)
	local xchannel =  xml:find("channel") or xml:find("rdf:RDF") or xml:find("feed")
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
		local pubDate = xitems[i]:find("pubDate") or xitems[i]:find("dc:date") or xitems[i]:find("updated")
		if not pubDate then print("PUBDATE NOT FOUND!") return end
		pubDate = pubDate[1]
		if string.sub(pubDate, 1, 1) == "2" then pubDate = dateUtils.DcToPub(pubDate) end
		if dateUtils.DateIsNewer(FEEDS[curFeed].lastDate, pubDate) then
			table.insert(xnewItems, xitems[i])
		end
		pubDate = nil
	end
	-- Print all new ones
	for i = 1, #xnewItems do
		local pubDate = xnewItems[i]:find("pubDate") or xnewItems[i]:find("dc:date") or xnewItems[i]:find("updated")
		pubDate = pubDate[1]
		if string.sub(pubDate, 1, 1) == "2" then pubDate = dateUtils.DcToPub(pubDate) end
		if not FEEDS[curFeed].firstTime then
			local link = xnewItems[i]:find("link")[1] or xnewItems[i]:find("id")[1]
			for i = 1, #CHANNELS do
				s:sendChat(CHANNELS[i], string.format("%s%s: %s <15%s>", FEEDS[curFeed].c, FEEDS[curFeed].name, xnewItems[i][1][1], link))
			end
			link = nil
		end
		if dateUtils.DateIsNewer(FEEDS[curFeed].lastDate, pubDate) then
			FEEDS[curFeed].lastDate = pubDate
		end
		pubDate = nil
	end
	print(FEEDS[curFeed].name .. " newest date: " .. FEEDS[curFeed].lastDate)
	FEEDS[curFeed].firstTime = nil
end

return { CheckFeed = CheckFeed }
