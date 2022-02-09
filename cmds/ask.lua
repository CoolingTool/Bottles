local replies = {"Yes", "No", "I don't know", "Bro what", "Nah", "Of course!", "Oh hell no...", "I guess", "Your choice"}

return function(message)
  message:reply{
		content = replies[math.random(#replies)],
			reference = {
    message = message,
    mention = false,
			}}
end