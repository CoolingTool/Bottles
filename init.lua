math.random(os.time())

_G.config = require('loadconfig')
_G.discordia = require('discordia')
_G.p = require('pretty-print-discordia').prettyPrint
_G.bot = discordia.Client{logFile=config.bools.noLogFile and '' or 'bot.log'}
_G.tles = require("tles")
_G.e = tles.emoji.index

local patts = tles.patts
local fs = require("coro-fs")
local json = require("json")
local dofile = require("dofile")
local l = require("lpeg")
local uv = require("uv")

local gprefix = config.prefix


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

function canReply(message)
    local user = message.author
    return (message.type == 0 and user ~= user.client.user and user.bot ~= true and user.discriminator ~= '0000')
end


bot:on('ready', function()
	print('Logged in as '.. bot.user.username)
	_G.starttime = os.time()
end)

bot:on('messageCreate', function(message)
	if not canReply(message) then return end
			
	local command, trail = detectCommand(message)
	if not command then return end

	if command == 'ask' or command == 'uptime' or command == 'thumbsup' or command == 'saxophone' or command == 'emojipack' or command == 'exec' then
		runCommand(command,message,trail)
	end
end)

--repl
if config.bools.webserver then tles.keepAlive.start() end

bot:run('Bot '..(config.token))