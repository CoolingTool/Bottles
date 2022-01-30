local lpeg = require("lpeg")
local locale = lpeg.locale()
local c = utf8.char

local tles = module.exports

--trim function from
--	http://lua-users.org/lists/lua-l/2009-12/msg00921.html
--space lists from
--	https://www.compart.com/en/unicode/bidiclass/B
--	https://www.compart.com/en/unicode/bidiclass/S
--	https://www.compart.com/en/unicode/bidiclass/WS
local space = 
	locale.space + c(0x1C) + c(0x1D) + c(0x1E) +
	c(0x1F) + c(0x85) + c(0x1680) + c(0x2000) +
	c(0x2001) + c(0x2002) + c(0x2003) + c(0x2004) +
	c(0x2005) + c(0x2006) + c(0x2007) + c(0x2008) +
	c(0x2009) + c(0x200A) + c(0x2028) + c(0x2029) +
	c(0x205F) + c(0x3000)
local nonspace = 1 - space
local patt = space^0 * lpeg.C((space^0 * nonspace^1)^0)

function tles.trim(str)
	return lpeg.match(patt,str)
end