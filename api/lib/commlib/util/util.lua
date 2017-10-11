local socket = require "socket"
local luaSocket = require "socket"
local sql_pb = require "sql_pb"

local U = {}

function U.CreatEnumTable(tbl, index)
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        tbl[v] = enumindex + i
    end
end

function U.sleep(n)
    socket.select(nil, nil, n)
end

function U.SendDataUseSocketSync(ip, port, data, tbl)
    ngx.log(ngx.DEBUG, " SendDataUseSocketSync begin ")
    local succ, sock = pcall(socket.connect, ip, port)
    if (not succ) or (nil == sock) then
        ngx.log(ngx.DEBUG, "socket.connect error... ")
        data = nil
        return
    else
        ngx.log(ngx.DEBUG, "socket.connect success:")
    end
    local t0 = luaSocket.gettime()
    sock:send(data)
    sock:settimeout(0)
    ngx.log(ngx.DEBUG, "sock send data OK ................................")
    recvt, sendt, status = socket.select({sock}, nil, 3)
    if #recvt > 0 then
        local t1 = luaSocket.gettime()
        ngx.log(ngx.DEBUG, "sock send_receive used time:" .. t1-t0 .. "s")

        local line, status, partial = sock:receive(100*1024)
        local t2 = luaSocket.gettime()
        ngx.log(ngx.DEBUG, "t2-t1 is "..t2-t1.."s")
        tbl["data"] = partial
        if status == "closed" or status == "timeout" then
        end
    end
    sock:close()
end

function U.isDataEnd(buffer)
    local service_response = sql_pb.Response()
    local success, res = pcall(service_response.ParseFromString,service_response,buffer)
    if not success then
        ngx.log(ngx.DEBUG, "##################parseFromString error "..res)
        if string.find(res, "Truncated") then
            return false
        else
            return false
        end
    else
        return true
    end
end

function U.SendDataUseSocketSyncCatch(ip, port, data, tbl)
    --ngx.log(ngx.DEBUG, " SendDataUseSocketSyncCatch begin ")

    tbl["data"] = ""
    local succ, sock = pcall(socket.connect, ip, port)
    if (not succ) or (nil == sock) then
        ngx.log(ngx.DEBUG, "socket.connect error... ")
        data = nil
        return
    else
        ngx.log(ngx.DEBUG, "socket.connect success:")
    end
    local t0 = luaSocket.gettime()
    sock:send(data)
    sock:settimeout(0)
    --ngx.log(ngx.DEBUG, "sock send data OK ................................")
    recvt, sendt, status = socket.select({sock}, nil, 3)
    while #recvt > 0 do
        local t1 = luaSocket.gettime()
        ngx.log(ngx.DEBUG, "sock send_receive used time:" .. t1-t0 .. "s")
        local line, status, partial = sock:receive(1000*1024)
        if nil ~= partial then
            tbl["data"] = tbl["data"]..partial
        end
        if U.isDataEnd(tbl["data"]) then
            break
        else
            if status ~= "closed" then
                recvt, sendt, status = socket.select({sock}, nil, 1)
                local t2 = luaSocket.gettime()
                ngx.log(ngx.DEBUG, "t2-t1 = " .. t2-t1 .. "s")
                ngx.log(ngx.DEBUG, "################in while, recvt length is "..#recvt)
            end
            if #recvt == 0 then
                local t3 = luaSocket.gettime()
                ngx.log(ngx.DEBUG, "recvt = 0, t3-t1 = " .. t3-t1 .. "s")
                break
            end
        end
        if status == "closed" or status == "timeout" then
            local t4 = luaSocket.gettime()
            ngx.log(ngx.DEBUG, "sock is closed or timeout. t4-t1 = " .. t4-t1 .. "s")
            break
        end
        local t5 = luaSocket.gettime()
        ngx.log(ngx.DEBUG, "sock send_receive used time:" .. t5-t0 .. "s")
    end
    sock:close()
end

function U.TableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function U.Hash(tbl)
    local tmp_tbl = {}
    for k, v in pairs(tbl) do
        tmp_tbl[v] = true
    end
    return tmp_tbl
end

function U.isTblKeyInHash(tbl, hash)
    for k, v in pairs(tbl) do
        ngx.log(ngx.DEBUG, "tbl k:"..k..";v:"..tostring(v))
        if nil == hash[k] then
            return false, k
        end
    end
    return true
end

function U.isValidINT32 (number)
    if (0 > number) or (number > 2147483647 ) then
        return false
    end
    return true
end

function U.countTB(tblData)
    local count = 0
    if nil ~= tblData then
        for k, v in pairs(tblData) do
            count = count +1
        end
    end
    return count
end

function U.isEmptyTable(tbl)
    return _G.next(tbl) == nil
end

function U.isSysTB(tblData)
    if nil ~= tblData then
        for k, v in pairs(tblData) do
            ngx.log(ngx.DEBUG, ".............tblData k is ".. k)
            if k == "lat" or
                    k == "lon" or
                    k == "timestamp" or
                    k == "country" or
                    k == "region" or
                    k == "city" or
                    k == "type" then
                return false
            end
        end
    end

    return true
end
return U
