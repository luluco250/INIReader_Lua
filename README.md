# INIReader_Lua
INI file parser for Lua.

Usage:

'''lua
require 'inireader'

local ini = inireader:new("/path/to/file.ini")
print(ini:get("category", "name", "defaultValue"))
'''
