             Francoise - An RSS reader bot for IRC written in Lua.

Introduction
------------
This is a simple RSS feed reader bot for IRC programmed in Lua.

License
-------
Released under the zlib license, see LICENSE.txt for full information.

Running
-------
To run the bot, simply call "lua francoise.lua", or double click francoise.lua
if you have a Lua installation like LuaForWindows. You can specify a different
config file by using the command line argument "--config". For example, running
"lua francoise.lua --config myNews" will start the bot using the configuration
information in the file "myNews.lua". You can also specify a config file that
is in a directory by using "lua francoise.lua --config dir/file". If you do not
specify the config argument, the bot will use the default "config.lua" file.

Dependencies
------------
Francoise depends on several external Lua libraries:
 - hump.timer (Included) - https://github.com/vrld/hump
 - LuaIRC - https://github.com/JakobOvrum/LuaIRC
 - LuaSocket - http://w3.impa.br/~diego/software/luasocket/
 - LuaSec (Only if using SSL) - http://www.inf.puc-rio.br/~brunoos/luasec/
 - LuaXML - http://viremo.eludi.net/LuaXML/
