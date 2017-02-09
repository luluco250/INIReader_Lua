--[[
	INI Reader by luluco250
--]]

local inireader = {}

local function clear(buffer)
	for i in pairs(buffer) do
		buffer[i] = nil
	end
end

function inireader:add(category, name, value)
	if (self[category] == nil) then
		self[category] = {}
	end
	self[category][name] = value
end

function inireader:get(category, name, default)
	if (self[category] == nil or self[category][name] == nil) then
		return default
	else
		return self[category][name]
	end
end

function inireader:new(path)
	local file = io.open(path)
	
	local map = { [""] = {} }
	setmetatable(map, self)
	self.__index = self
	
	
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
					--[[
						Fill 'category' with the contents of buffer, 
						clear it and exit the loop.
					--]]
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
				--[[
					Fill 'name' with the buffer,
					clear it and move to the next character.
				--]]
				if (c == '=') then
					name = table.concat(buffer)
					clear(buffer)
				else
					table.insert(buffer, c)
					--[[
						If we're on the last character,
						fill 'value' with the buffer,
						clear it and break the loop.
					--]]
					if (i == #line) then
						value = table.concat(buffer)
						break
					end
				end
			end
			clear(buffer)
			--each line in the file
			map:add(category, name, value)
		end
	end
	
	file:close()
	return map
end

return inireader