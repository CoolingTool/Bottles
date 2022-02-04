math.random(os.time())

_G.isrepl = process.env.REPL_OWNER

_G.discordia = require('discordia')
_G.bot = discordia.Client{logFile=isrepl and '' or 'bot.log'}
_G.tles = require("tles")

local fs = require("coro-fs")
local json = require("json")
local dofile = require("dofile")


local gprefix = '!'


local function detectCommand(message)
	local content = message.content

	-- starts with prefix
	if string.find(content, gprefix, 1, true) == 1 then

		-- first word after prefix is command
		local i, j = string.find(content, "%w+", #gprefix+1)

		if i then
            -- return command name and everything after command name
			return content:sub(i,j):lower(), tles.trim(content:sub(j+1))
		else 
			return nil
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

	if command == 'thumbsup' or command == 'saxophone' or command == 'emojipack' then
		runCommand(command,message,trail)
	end
end)

--repl
if isrepl then tles.keepAlive.start() end

bot:run('Bot '..(process.env.TOKEN or assert(fs.readFile("TOKEN"))))