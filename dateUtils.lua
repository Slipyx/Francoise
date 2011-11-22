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

-- Localize some std functions
local sub = string.sub
local tonumber = tonumber
local format = string.format

-- Month nums table for comparing pub dates
local monthNums = {Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
				   Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12}
-- Reverse of above
local numMonths = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}

-- Returns true if second arg is newer than first arg
local function DateIsNewer(old, new)
	local oldTok = {} -- Date token tables
	local newTok = {}

	oldTok.year = tonumber(sub(old, 13, 16)) -- Year
	newTok.year = tonumber(sub(new, 13, 16))
	oldTok.month = sub(old, 9, 11) -- Month
	newTok.month = sub(new, 9, 11)
	oldTok.mday = tonumber(sub(old, 6, 7)) -- Month day
	newTok.mday = tonumber(sub(new, 6, 7))
	oldTok.hour = tonumber(sub(old, 18, 19)) -- Hours
	newTok.hour = tonumber(sub(new, 18, 19))
	oldTok.min = tonumber(sub(old, 21, 22)) -- Minutes
	newTok.min = tonumber(sub(new, 21, 22))
	oldTok.sec = tonumber(sub(old, 24, 25)) -- Seconds
	newTok.sec = tonumber(sub(new, 24, 25))

	---[[
	if newTok.year > oldTok.year then -- Year is newer
		return true
	elseif newTok.year < oldTok.year then -- Year is older
		return false
	elseif monthNums[newTok.month] > monthNums[oldTok.month] then -- Month is newer
		return true
	elseif monthNums[newTok.month] < monthNums[oldTok.month] then -- Month is older
		return false
	elseif newTok.mday > oldTok.mday then -- Month day is newer
		return true
	elseif newTok.mday < oldTok.mday then -- Month day is older
		return false
	elseif newTok.hour > oldTok.hour then -- Hour is newer
		return true
	elseif newTok.hour < oldTok.hour then -- Hour is older
		return false
	elseif newTok.min > oldTok.min then -- Minute is newer
		return true
	elseif newTok.min < oldTok.min then -- Minute is older
		return false
	elseif newTok.sec > oldTok.sec then -- Second is newer
		return true
	elseif newTok.sec < oldTok.sec then -- Second is older
		return false
	end
	--]]

	return false
end

-- Converts a dc:date string to a pubDate string
local function DcToPub(dcdate)
	local pdate = format("Nou, %s %s %s %s", sub(dcdate, 9, 10), numMonths[tonumber(sub(dcdate, 6, 7))],
        sub(dcdate, 1, 4), sub(dcdate, 12, 19))
	return pdate
end

return {
	DateIsNewer = DateIsNewer,
	DcToPub = DcToPub
}
