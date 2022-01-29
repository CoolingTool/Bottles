--library to get emoji from the name of the emoji

local json = require("json")
local fs = require("fs")

local shortcodes = {}

--these come from discord apk, dont remember what folder but its not hard to find
shortcodes.main = json.parse(fs.readFileSync("libs/shortcodes/emojis.json"))
shortcodes.shortcuts = json.parse(fs.readFileSync("libs/shortcodes/emoji-shortcuts.json"))
shortcodes.cache = {}

function shortcodes:getEmoji(query)
    if self.cache[query] then
        return self.cache[query]
    end

    if not query:match("^[%w_%+%-]+$") then
        for i, emoji in pairs(self.shortcuts) do
            for i, shortcut in pairs(emoji.shortcuts) do
                if shortcut == query then query = emoji.emoji break end
            end
            if query:match("^[_%w]+$") then break end
        end
    end

    query = query:match('^:?(.-):?$'):lower()

    for i, category in pairs(self.main) do
        for i, emoji in pairs(category) do
            for i, name in pairs(emoji.names) do
                if name == query then
                    self.cache[query] = emoji.surrogates
                    return emoji.surrogates
                end
                if emoji.hasDiversity then
                    for i, child in pairs(emoji.diversityChildren) do
                        for i, cname in pairs(child.names) do
                            if cname == query then
                                self.cache[query] = child.surrogates
                                return child.surrogates
                            end
                        end
                    end
                end
            end
        end
    end
end

function shortcodes:makeEmojiLookupTable()
    return setmetatable({}, {
        __index = function(t, ...) return self:getEmoji(...) end
    })
end

return shortcodes