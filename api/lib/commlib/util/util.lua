-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了通用功能
-- 函数命名必须为小写字母加下划线区分功能单词 例: encode_request_header
-- *********************************************************************************************************

local socket = require "socket"

local util = {}

function util:create_enum_table(tbl, index)
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        tbl[v] = enumindex + i
    end
end

function util:send_data_use_socket_sync(ip, port, data, timeout)
    local succ, sock = pcall(socket.connect, ip, port)
    if (not succ) or (nil == sock) then
        return false,("connect to service ip:" .. ip .. " port:" .. tostring(port) .. " failed")
    end
    sock:send(data)
    sock:settimeout(0)
    local recieve_data = ""
    local has_datas = false
    local recvt, sendt, status = socket.select({sock}, nil, timeout)
    while #recvt > 0 do
        local line, status, partial = sock:receive(1000*1024)
        if nil ~= partial then
            recieve_data = recieve_data .. partial
            has_datas = true
        end

        if status == "closed" then
            break;
        end

        recvt, sendt, status = socket.select({sock}, nil, 0.01)
        if #recvt <= 0 or status == "closed" then
            break;
        end
    end
    sock:close()

    if false == has_datas then
        return false, ("service ip:" .. ip .. " port:" .. tostring(port) .. " has no response")
    end

    return true, recieve_data
end

function util:is_valid_int(number)
    if (0 > number) or (number > 2147483647 ) then
        return false
    end
    return true
end

function util.is_empty_table(tbl)
    return _G.next(tbl) == nil
end

function util:table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

return util
