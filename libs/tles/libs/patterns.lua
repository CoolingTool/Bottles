local lpeg = require("lpeg")
local c = utf8.char

local patterns = module.exports


patterns.locale = lpeg.locale()

patterns.space = patterns.locale.space + c(0x1C) + c(0x1D) + c(0x1E) +
					c(0x1F) + c(0x85) + c(0x1680) + c(0x2000) +
					c(0x2001) + c(0x2002) + c(0x2003) + c(0x2004) +
					c(0x2005) + c(0x2006) + c(0x2007) + c(0x2008) +
					c(0x2009) + c(0x200A) + c(0x2028) + c(0x2029) +
					c(0x205F) + c(0x3000)
patterns.notspace = 1 - patterns.space