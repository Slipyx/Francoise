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

-- Month nums table for comparing pub dates
local monthNums = {Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
				   Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12}
-- Reverse of above
local numMonths = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}

-- Returns true if second arg is newer than first arg
local function DateIsNewer(old, new)
	local oldTok = {} -- Date token tables
	local newTok = {}

	oldTok.year = string.sub(old, 13, 16) -- Year
	newTok.year = string.sub(new, 13, 16)
	oldTok.month = string.sub(old, 9, 11) -- Month
	newTok.month = string.sub(new, 9, 11)
	oldTok.mday = string.sub(old, 6, 7) -- Month day
	newTok.mday = string.sub(new, 6, 7)
	oldTok.hour = string.sub(old, 18, 19) -- Hours
	newTok.hour = string.sub(new, 18, 19)
	oldTok.min = string.sub(old, 21, 22) -- Minutes
	newTok.min = string.sub(new, 21, 22)
	oldTok.sec = string.sub(old, 24, 25) -- Seconds
	newTok.sec = string.sub(new, 24, 25)

	---[[
	if tonumber(newTok.year) > tonumber(oldTok.year) then -- Year is newer
		return true
	elseif tonumber(newTok.year) < tonumber(oldTok.year) then -- Year is older
		return false
	elseif monthNums[newTok.month] > monthNums[oldTok.month] then -- Month is newer
		return true
	elseif monthNums[newTok.month] < monthNums[oldTok.month] then -- Month is older
		return false
	elseif tonumber(newTok.mday) > tonumber(oldTok.mday) then -- Month day is newer
		return true
	elseif tonumber(newTok.mday) < tonumber(oldTok.mday) then -- Month day is older
		return false
	elseif tonumber(newTok.hour) > tonumber(oldTok.hour) then -- Hour is newer
		return true
	elseif tonumber(newTok.hour) < tonumber(oldTok.hour) then -- Hour is older
		return false
	elseif tonumber(newTok.min) > tonumber(oldTok.min) then -- Minute is newer
		return true
	elseif tonumber(newTok.min) < tonumber(oldTok.min) then -- Minute is older
		return false
	elseif tonumber(newTok.sec) > tonumber(oldTok.sec) then -- Second is newer
		return true
	elseif tonumber(newTok.sec) < tonumber(oldTok.sec) then -- Second is older
		return false
	end
	--]]

	return false
end

-- Converts a dc:date string to a pubDate string
local function DcToPub(dcdate)
	local pdate = "Nou, " .. string.sub(dcdate, 9, 10) .. " " .. numMonths[tonumber(string.sub(dcdate, 6, 7))] .. " " .. string.sub(dcdate, 1, 4) .. " " .. string.sub(dcdate, 12, 19)
	return pdate
end

return {
	DateIsNewer = DateIsNewer,
	DcToPub = DcToPub
}
