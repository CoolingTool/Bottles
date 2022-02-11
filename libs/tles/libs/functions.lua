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


function exports.tuplePack(...)
	local packed = table.pack(...)
	packed.i = select('#', ...)
	return packed
end

function exports.tupleUnpack(packed)
	return table.unpack(packed, 1, packed.i)
end


function exports.round(n, i)
	local m = 10 ^ (i or 0)
	return math.floor(n * m + 0.5) / m
end