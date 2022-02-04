local list = tles.emoji.list

return function(message)
  local emoji = list[math.random(#list)]

  local thumbsup = tles.emoji.index.thumbsup
  if emoji.diversity then
    local b = tonumber(emoji.diversity[#emoji.diversity], 16)

    thumbsup = thumbsup .. utf8.char(b)
  end

  message:reply(emoji.surrogates..thumbsup)
end