local l = require("lpeg")

local patts = require("patts")

local exports = module.exports

function exports.startswith(subject, str)
    return string.find(subject, str, 1, true) == 1
end

local patt = patts.s^0 * l.C((patts.s^0 * patts.S^1)^0)
function exports.trim(str)
	return l.match(patt,str)
end

