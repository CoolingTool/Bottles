-- download all the emojis in a server and zip them up for archiving

local miniz = require("miniz")
local http = require("coro-http")
local split = require("coro-split")
local url = require("url")
local path = require("path")

return function(message)
	local guild = message.guild

	if not guild then 
		message:reply("This command can only run in servers")
		return
	end

	if #guild.emojis == 0 then
		message:reply("This server has no emojis")
		return
	end

	local ping = message:reply("Please wait")
	message.channel:broadcastTyping()



	local emojisLeft = guild.emojis:toArray()
	local writer = miniz.new_writer()

	local function downloader()
		while #emojisLeft ~= 0 do
			-- table.remove returns removed item 
			local emoji = table.remove(emojisLeft)

			--p('downloading '..emoji.name, #emojisLeft)

			local ok, res, data = pcall(http.request, 'GET', emoji.url)

			--p('downloaded '..emoji.name)

			if ok then
				local ext = path.extname(url.parse(emoji.url).pathname)

				-- 9 is compression amount i believe
				writer:add(emoji.name..ext, data, 9) 
			end
		end
	end

	-- parallel downloading baby
	split(downloader, downloader, downloader)

	ping:setContent("Uploading")

	local zip = writer:finalize()

	if zip then
		local ok = message:reply{file={"emojis.zip",zip}}

		if not ok then
			message:reply("Upload failed. (likely because the file was too big)")
		end

		ping:delete()
	else
		message:reply("Command failed.")
	end
end