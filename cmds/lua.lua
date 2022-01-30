local tles = require("tles")

return function(message, content)
	if not content then return end
    if message.author ~= bot.owner then 
    	return
    end

    message:reply("hi "..tles.trim(content))
end
