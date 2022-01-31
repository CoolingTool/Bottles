local lpeg = require("lpeg")

local patterns = require("patterns")

local exports = module.exports


local patt = patterns.space^0 * lpeg.C((patterns.space^0 * patterns.notspace^1)^0)
function exports.trim(str)
	return lpeg.match(patt,str)
end