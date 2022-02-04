local e = require("tles").emoji.index

local keys = {}
for i in pairs(e) do
  keys[#keys+1] = i
end

return function(message)
    message:reply(e[keys[math.random(#keys)]]..e.thumbsup)
end