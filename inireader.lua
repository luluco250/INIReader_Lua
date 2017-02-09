--[[
	INI File Reader
	
	Returns a dictionary table separated 
	in categories with names in them.
	
	dictionary:get(category, name, default)
	Fetches values, returns 'default' if it
	doesn't exist.
	
	dictionary?add(category, name, value)
	Adds values to the dictionary, also
	categories if necessary.
--]]

local function clear(buf)
	for i in pairs(buf) do
		buf[i] = nil
	end
end

local file = io.open(...)

local dictionary = {
	add = function(t,c,n,v)
		if (t[c] == nil) then
			t[c] = {}
		end
		t[c][n] = v
	end,
	get = function(t,c,n,d)
		if (t[c] == nil or t[c][n] == nil) then
			return d
		else
			return t[c][n]
		end
	end,
	[""] = {}
}

local buffer = {""}
local category = ""
local name = ""
local value = ""

for line in file:lines() do
	if (line:sub(1,1) == '[') then
		--build category
		for i = 2, #line do
			local c = line:sub(i,i)
			if (c == ']') then
				--fill 'category' with the
				--contents of buffer, clear it
				--and exit the loop
				category = table.concat(buffer)
				clear(buffer)
				break
			else
				table.insert(buffer, c)
			end
		end
	elseif not (line:sub(1,1) == ';' or line:sub(1,1) == '#') then
		for i = 1, #line do
			--each character in the current line
			local c = line:sub(i,i)
			--fill 'name' with the buffer,
			--clear it and move to the next character
			if (c == '=') then
				name = table.concat(buffer)
				clear(buffer)
			else
				table.insert(buffer, c)
				--if we're on the last character,
				--fill 'value' with the buffer,
				--clear it and break the loop
				if (i == #line) then
					value = table.concat(buffer)
					break
				end
			end
		end
		clear(buffer)
		--each line in the file
		dictionary:add(category, name, value)
	end
end

file:close()

return dictionary

