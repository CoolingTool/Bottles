local http = require('coro-http')
local timer = require('timer')

local res_payload = "Hello!"
local res_headers = {
   {"Content-Length", tostring(#res_payload)},
   {"Content-Type", "text/plain"},
   code = 200,
   reason = "OK",
}

function module.exports.start()
  http.createServer("0.0.0.0", 8080, function(req, body)
    return res_headers, res_payload
  end)
end
