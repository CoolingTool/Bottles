return function(message)
	local mentioned = message.mentionedUsers.first

	print(tostring(mentioned))

	if not mentioned then message:reply("mention user in command please") return end

	message:reply{embed={
		title=mentioned.tag
	}}
end