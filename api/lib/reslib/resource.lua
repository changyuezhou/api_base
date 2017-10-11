local manager = require "cache_manager"
local Resource = {}
function Resource:new(ip, port)
  local o = {}
  o.IP = ip
  o.PORT = port
  
  if nil == ip then
    o.IP = "127.0.0.1"
  end
  
  if nil == port then
    o.PORT = 10000
  end
  
  setmetatable(o, {__index=manager})
  manager:setIpPort(o.IP, o.PORT)
  
  return o
end

return Resource