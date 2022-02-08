local uv = require("uv")

return function(message)
    message:reply("started <t:".._G.starttime..":R>")
end