local uv = require("uv")

return function(message)
    message:reply("started <t:".._G.starttime..":R> ||(or "..discordia.Time.fromSeconds(os.time() - _G.starttime):toString()..")||")
end