local list = tles.emoji.list

return function(message)
  local emoji = list[math.random(#list)]

  local thumbsup = tles.emoji.index.thumbsup

  local d = emoji.diversity
  if d then
    local b = tonumber(d[#d], 16)

    thumbsup = thumbsup .. utf8.char(b)
  end
  
  message:reply(emoji.surrogates..thumbsup)
end