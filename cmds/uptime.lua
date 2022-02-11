local uv = require("uv")
local Time = discordia.Time

local template =
[[bot started <t:%s:R> ||or %s||
bot last connected to discord at <t:%s:R> ||or %s||]]

local function startedAt(st)
    return tles.round(os.time() - st:toSeconds())
end

return function(message)
    local bst = bot.uptime
    local lcst = _G.lastConnectionStartTime:getTime()

    message:reply(template:format(
        startedAt(bst), bst:toString(),
        startedAt(lcst), lcst:toString()
    ))
end