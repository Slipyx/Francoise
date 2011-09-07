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

local function log(msg)
	local t = date("*t")
	local ts = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
	print(string.format("[%s] %s", ts, msg))
end

return { log = log }
