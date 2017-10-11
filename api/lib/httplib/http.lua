--
-- Created by IntelliJ IDEA.
-- User: John
-- Date: 2017/7/18
-- Time: 19:36
-- To change this template use File | Settings | File Templates.
--
local zhttp = require "http_util"
local cjson = require "cjson"
local HttpUtil = {}

function HttpUtil:https_client(strPath, body, sMethod, timeout, response)
    ngx.log(ngx.DEBUG,"==========in function https_post_client ------------------ ")
    local httpc = zhttp.new()
    timeout = timeout or 30000
    httpc:set_timeout(timeout)
    local res = httpc:request_uri(strPath, {
        ssl_verify = false,
        method = sMethod,
        body = body,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })
    if res.status ~= 200 then
        ngx.log(ngx.DEBUG,"---------- ~=200 in function https_client ------------ ")
        return nil
    end

    ngx.log(ngx.DEBUG,"=====200=== body:" ..res.body .. " ------------------ ")
    local text = res.body
    local success, jsonTbl = pcall(cjson.decode, text)
    if not success then
        ngx.log(ngx.DEBUG,"============== success not true in function https_client ------------------ ")
        ngx.log(ngx.DEBUG, "cjson.decode fail "..jsonTbl)
        response["code"] = -1
        response["msg"] = "Invalid cjson format for response from auth server."
        return nil
    end
    return jsonTbl
end

function HttpUtil:http_client(strPath, body, sMethod, timeout, response)
    ngx.log(ngx.DEBUG,"==========in function https_post_client ------------------ ")
    local httpc = zhttp.new()
    timeout = timeout or 30000
    httpc:set_timeout(timeout)
    local res = httpc:request_uri(strPath, {
        method = sMethod,
        body = body,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })
    if res.status ~= 200 then
        ngx.log(ngx.DEBUG,"===== ~=200 ======in function http_client ------------------ ")
        return nil
    end
    ngx.log(ngx.DEBUG,"============200 ======== body:" ..res.body .. " ------------------ ")
    local text = res.body
    local success,jsonTbl = pcall(cjson.decode, text)
    if not success then
        ngx.log(ngx.DEBUG,"====== success not true in function http_client ----------- ")
        ngx.log(ngx.DEBUG, "cjson.decode fail "..jsonTbl)
        response["code"] = -1
        response["msg"] = "Invalid cjson format for response from auth server."
        return nil
    end
    return jsonTbl
end

return HttpUtil