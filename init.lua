math.random(os.time())

_G.discordia = require('discordia')
_G.client = discordia.Client()

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

		return content:sub(i,j), content:sub(j+1)
	end

	return nil
end

local function runCommand(path, ...)
	return dofile('./commands/'..path)(...)
end



client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
	local command, trail = detectCommand(message)
	if not command then return end

	if command == 'ping' then
		message.channel:send{content='Pong!', reference={message=message, mention=false}}
	end

	if command == 'saxophone' or command == 'user' or command == 'emojizip' then
		runCommand(command,message)
	end
end)


client:run('Bot '..fs.readFile("TOKEN"))