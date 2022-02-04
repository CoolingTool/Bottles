-- run lua file using luvit's own require function
-- this also caches files but reloads if they were edited
local path = require('path')
local fs = require('coro-fs')
local makeModule = require('require')
local join = path.join
local resolve = path.resolve

local errlvl = 5

local cache = {}

return function(path, env)
    path = resolve(path)

    local attempt = 1

    ::tryagain::

    local stat = fs.lstat(path)

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
            err('could not find '..path)
        end
    end

    local c = cache[path]
    if c and c.mtime.sec > stat.mtime.sec then
        if not c.t[1] then err(c.t[2], errlvl) end
    
        return select(2, table.unpack(c.t))
    end

    local fn, err = loadfile(path)
    cache[path] = {mtime=stat.mtime,t={fn,err}}
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
    cache[path] = {mtime=stat.mtime,t=t}
    if not t[1] then error(t[2], errlvl) end

    return select(2, table.unpack(t))
end