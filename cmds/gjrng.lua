local request = require("coro-http"). request

local host = 'https://gamejolt.com'
local header = {{'User-Agent', 'Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)'}}
-- pretend to be discord : troll :

return function(message)
    for i = 1, 30 do
        local link = host..'/games/a/'..math.random(2,670000)
        -- as of december 10th 2021 games above 670000 don't exist
        
        local succ, res = pcall(request, 'HEAD', link, header)

        if res.code == 301 then
            for i = 1, #res do
                local key, location = unpack(res[i])
                if key == "location" then
                    message:reply(host .. location) return
                end
            end
        end
    end

    message:reply('couldnt find a game')
	end