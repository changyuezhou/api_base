-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了LUA代码访问外部HTTP SERVICE的功能
--
-- *********************************************************************************************************

local proxy = {}

function proxy:set_nginx_proxy_request(proxy_path, path, request_method, post_body, url_args)
    local cjson = require "cjson"
    local url = proxy_path .. path
    ngx.req.set_header("Content-Type", "application/json;charset=utf8")
    ngx.req.set_header("Accept", "application/json");

    local res = ngx.location.capture(url, {
        method = request_method,
        body = cjson.encode(post_body),
        args = url_args
    })

    if res.status ~= 200 then
        return false, "服务器返回码:" .. tostring(res.status)
    end

    local ok, tbl = pcall(cjson.decode, res.body)
    if not ok or nil == tbl or nil == tbl.code then
        return false, "服务器返回数据格式错误,数据:" .. res.body
    end

    return true, tbl
end

return proxy