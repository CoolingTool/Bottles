local pp = require('pretty-print')

local global = setmetatable({
	require=require, uv=require("uv"),
},{__index=_G})

pp.loadColors(16)

local function printLine(...)
    local ret = {}
    for i = 1, select('#', ...) do
        local arg = tostring(select(i, ...))
        table.insert(ret, arg)
    end
    return table.concat(ret, '\t')
end

local function prettyLine(...)
    local ret = {}
    for i = 1, select('#', ...) do
		local arg = pp.dump(select(i, ...))
        table.insert(ret, arg)
    end
    return table.concat(ret, '\t')
end

return function(message, trail)
	if message.author ~= bot.owner then message:reply(e.hear_no_evil) return end
	if not trail then message:reply("exec yo mama") return end
	
	local code = trail:match('^```lua\n(.-)```$') or trail 

	local lines = {}

	local sandbox = setmetatable({},{__index=global})

	sandbox.message = message
	sandbox.reply = function(...) return message:reply(...) end
	sandbox.ref = message.referencedMessage

	sandbox.print = function(...) table.insert(lines, printLine(...)) end
    sandbox.p = function(...) table.insert(lines, prettyLine(...)) end
	
	local f, err = load('return '..code, "EXEC", 't', sandbox)
	if err then
		f, err = load(code, "EXEC", 't', sandbox)
	end
	
	if err then error(err, 0) end
    
	t = tles.tuplePack(f())

	if t.i > 0 then sandbox.p(tles.tupleUnpack(t)) end

	if #lines > 0 then
		local out = table.concat(lines, '\n')

		local content = '>>> ```ansi\n'..table.concat(lines, '\n')..'```'

		if utf8.len(content) > 2000 then
			assert(message:reply{file={'out.ansi',out}})
		else
			assert(message:reply(content))
		end
	end
end