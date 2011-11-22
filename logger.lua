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

local date = os.date
local print = print
local format = string.format
local tostring = tostring

local function log(...)
	local vargs = {...}
	local logString = ""

	if #vargs >= 1 then logString = format("%s", tostring(vargs[1]))
		for i = 2, #vargs do
			logString = format("%s      %s", logString, tostring(vargs[i]))
		end
	end

	print(format("[%s] %s", date("%Y.%m.%d %H.%M.%S"), logString))
end

return log
