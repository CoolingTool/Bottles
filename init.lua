math.random(os.time())

_G.isrepl = process.env.REPL_OWNER

_G.discordia = require('discordia')
_G.bot = discordia.Client{logFile=isrepl and '' or 'bot.log'}
_G.tles = require("tles")
_G.e = tles.emoji.index

local patts = tles.patts
local fs = require("coro-fs")
local json = require("json")
local dofile = require("dofile")
local l = require("lpeg")


local gprefix = '!'


local cmdPatt = patts.s^0 * l.C(patts.w^1) * patts.s^0 * l.C(l.P(1)^0)
local function detectCommand(message)
	local content = message.content
	if tles.startswith(content, gprefix) then

		local command, trail = l.match(cmdPatt, content, #gprefix+1)
	
    	if command then
			return command:lower(), trail ~= '' and trail or nil
		end
	end
	return nil
end

local function runCommand(path, message, ...)
    local ok, err = pcall(dofile, './cmds/'..path)
	if ok then ok, err = pcall(err, message, ...) end

    if not ok then
        message:reply("command failed, reason: "..err)
    end
end



bot:on('ready', function()
	print('Logged in as '.. bot.user.username)
end)

bot:on('messageCreate', function(message)
	local command, trail = detectCommand(message)
	if not command then return end

	if command == 'thumbsup' or command == 'saxophone' or command == 'emojipack' or command == 'exec' then
		runCommand(command,message,trail)
	end
end)

--repl
if isrepl then tles.keepAlive.start() end

bot:run('Bot '..(process.env.TOKEN or assert(fs.readFile("TOKEN"))))