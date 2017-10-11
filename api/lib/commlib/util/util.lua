-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了通用功能
-- 函数命名必须为小写字母加下划线区分功能单词 例: encode_request_header
-- *********************************************************************************************************

local socket = require "socket"

local U = {}

function U.create_enum_table(tbl, index)
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        tbl[v] = enumindex + i
    end
end

function U.send_data_use_socket_sync(ip, port, data, timeout)
    local succ, sock = pcall(socket.connect, ip, port)
    if (not succ) or (nil == sock) then
        return false
    end
    sock:send(data)
    sock:settimeout(0)
    local recvt, sendt, status = socket.select({sock}, nil, timeout)
    local recieve_data = ""
    local has_datas = false
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
        return false
    end

    return true, recieve_data
end

function U.is_valid_int(number)
    if (0 > number) or (number > 2147483647 ) then
        return false
    end
    return true
end

function U.is_empty_table(tbl)
    return _G.next(tbl) == nil
end

return U
