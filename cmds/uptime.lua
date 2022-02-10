local uv = require("uv")
local Time = discordia.Time

return function(message)
    message:reply("started <t:".._G.starttime..":R> ||(or "..Time.fromSeconds(os.time()-_G.starttime):toString()..")||")
end