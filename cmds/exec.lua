local pp = require('pretty-print-discordia')

local global = setmetatable({
	module=module, require=require, uv=require("uv"), l=require("lpeg"), patts=tles.patts,
	fs=require("coro-fs"), json=require("json"),
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

local function prettyLineStrip(...)
    local ret = {}
    for i = 1, select('#', ...) do
		local arg = pp.strip(pp.dump(select(i, ...)))
        table.insert(ret, arg)
    end
    return table.concat(ret, '\t')
end

return function(message, trail)
	if message.author ~= bot.owner then return message:reply(e.hear_no_evil) end
	if not trail then return message:reply("exec yo mama") end
	
	local code = trail:match('^```lua\n(.-)```$') or trail 

	local lines = {}

	local sandbox = setmetatable({},{__index=global})

	sandbox.message = message
	sandbox.reply = function(...) return message:reply(...) end
	sandbox.ref = message.referencedMessage

	sandbox.print = function(...) table.insert(lines, printLine(...)) end
    sandbox.p = function(...) table.insert(lines, prettyLine(...)) end
	sandbox.ps = function(...) table.insert(lines, prettyLineStrip(...)) end
	
	local f, err = load('return '..code, "EXEC", 't', sandbox)
	if err then
		f, err = load(code, "EXEC", 't', sandbox)
	end
	
	if err then error(err, 0) end
    
	t = tles.tuplePack(f())

	if t.i > 0 then sandbox.p(tles.tupleUnpack(t)) end

	if #lines > 0 then
		local out = table.concat(lines, '\n')

		local content = '```ansi\n'..table.concat(lines, '\n')..'\n```'

		if utf8.len(content) > 4048 then
			message:reply{file={'message.ansi',out..'\n'}}
		elseif utf8.len(content) > 2000 then
			message:reply{embed={description=content}}
		else
			message:reply(content)
		end
	end
end