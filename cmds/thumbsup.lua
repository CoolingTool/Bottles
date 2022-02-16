local list = tles.emoji.list


return function(message)
  local emoji = list[tles.uvrandom(1, #list)]

  local thumbsup = math.random(1,100) == 1 and e.thumbsdown or e.thumbsup

  local d = emoji.diversity
  if d then
    local b = tonumber(d[#d], 16)

    thumbsup = thumbsup .. utf8.char(b)
  end
  
  message:reply(emoji.surrogates..thumbsup)
end