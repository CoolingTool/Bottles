-- run lua file using luvit's own require function
-- this also caches files but reloads if they were edited
local fs = require 'coro-fs'
local makeModule = require 'require'
local join = require 'path'.join
local resolve = require 'path'.resolve

local errlvl = 0

local resolveCache = {}
local retCache = {}

return function(ogpath, env)
    local path, stat
	if resolveCache[ogpath] then
		path = resolveCache[ogpath]
		stat = fs.lstat(path)
		if not stat then
			error('could not find '..ogpath)
		end
	else
		path = resolve(ogpath)

		local attempt = 1

		::tryagain::

		stat = fs.lstat(path)

		if stat then
			if stat.type == 'directory' then
				path = join(path, 'init.lua')
			end
		else
			if attempt == 1 then
				attempt = attempt + 1
				path = path..'.lua'
				goto tryagain
			else
				error('could not find '..ogpath)
			end
			resolveCache[ogpath] = path
		end
	end

    local c = retCache[path]
    if c and c.mtime.sec > stat.mtime.sec then
        if not c.t[1] then error(c.t[2], errlvl) end
    
        return select(2, table.unpack(c.t))
    end

    local fn, err = loadfile(path)
    retCache[path] = {mtime=stat.mtime,t={fn,err}}
    if not fn then error(err, errlvl) end

    local require, module = makeModule(path)

    env = env or {}
    env.module = module; env.require = require
    
    local sandbox = setmetatable(
        env,
        {__index = _G}
    )
    setfenv(fn, sandbox)
    
    -- use table.pack to accept file returning tuples
    local t = table.pack(pcall(fn))
    retCache[path] = {mtime=stat.mtime,t=t}
    if not t[1] then error(t[2], errlvl) end

    return select(2, table.unpack(t))
end