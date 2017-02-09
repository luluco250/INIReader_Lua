--[[
	INI Reader by luluco250
--]]

local inireader = {}

inireader.map = { [""] = {} }

local clear(buffer)
	for i = 1, #buffer do
		buffer[i] = nil
	end
end

function inireader.del(this)
	for i = 1, #this.map do
		this[i] = nil
	end
end

function inireader.add(this, category, name, value)
	if (this[category] == nil) then
		this[category] = {}
	end
	this[category][name] = value
end

function inireader.get(this, category, name, default)
	if (this[category] == nil or this[category][name] == nil) then
		return default
	else
		return this[category][name]
	end
end

function inireader.new(this, path)
	local file = io.open(path)
	
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
			this:add(category, name, value)
		end
	end
	
	file:close()
	
end

return inireader
