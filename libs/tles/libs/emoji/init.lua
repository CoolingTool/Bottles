local json = require("json")
local fs = require("coro-fs")
local path = require("path")

local emoji = module.exports

-- this is hell
emoji.categories = json.parse(assert(fs.readFile(path.resolve(module.dir,"emojis.json"))))
emoji.shortcuts = json.parse(assert(fs.readFile(path.resolve(module.dir,"emoji-shortcuts.json"))))

emoji.index = {}

local function indexEmoji(e)
	for i, n in pairs(e.names) do
		emoji.index[n] = e.surrogates
	end
end

for i, c in pairs(emoji.categories) do
	for i, e in pairs(c) do
		indexEmoji(e)

		if e.hasDiversity then
			for i, d in pairs(e.diversityChildren) do
				indexEmoji(d)
			end
		end
	end
end