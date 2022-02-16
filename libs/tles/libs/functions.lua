local l = require("lpeg")
local uv = require 'uv'
local bit = require 'bit'


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

function exports.uvrandom(min, max)
    assert(min, 'expected lower bound')
    assert(max, 'expected upper bound')
    assert(max > min, 'expected max > min')
    local range = max - min
    
    local log256range = math.ceil(math.log(range, 256)) -- number of bytes required to store range

    local bytes = uv.random(log256range * 2) -- get double the bytes required so we can distribute evenly with modulo
    local random = 0

    for i = 1, #bytes do
        random = bit.lshift(random, 8) + bytes:byte(i, i)
    end
    
    return random % range + min
	end