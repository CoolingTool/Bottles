local ini = require("ini")

local ok, config = pcall(ini.parse_file, ".conf")

if not ok then error(config.."\n\nmake sure you copied .conf.example to .conf and changed whats necessary") end

local function env(str)
	return str:gsub("%$(%w+)", process.env)
end

local function recursive(t)
	for i, v in pairs(t) do 
		if type(v) == 'string' then
			if v == 'true' then
				t[i] = true
			elseif v == 'false' then
				t[i] = false
			else
				t[i] = env(v)
			end
		elseif type(v) == 'table' then
			recursive(v)
		end
	end
	return t
end

return recursive(config)